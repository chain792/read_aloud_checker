<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
    <!-- ブックマークボタン -->
    <div class="d-flex justify-end">
      <!-- Array.includesが配列の要素と異なる型の値を受け取るとコンパイルエラーが起こるためany[]型にキャストして対処 
        https://qiita.com/namtok/items/34292d482f67a6064bbb -->
      <div v-if="progress" class="mr-5 bookmark-btn">
        <v-progress-circular
          size="20"
          color="grey-darken-5"
          indeterminate
          width="3"
          class="progress"
        ></v-progress-circular>
      </div>
      <v-btn v-else-if="(bookmarkUserIds as any[]).includes(userStore.authUser?.id)" class="bookmark-btn mr-5" elevation="0" icon @click="unbookmark">
        <v-tooltip activator="parent" location="top">
          <p class="tooltip">ブックマーク解除</p>
        </v-tooltip>
        <v-icon class="bookmark-icon" color="grey-darken-3">mdi-bookmark-check</v-icon>
      </v-btn>
      <v-btn v-else class="bookmark-btn mr-5" elevation="0" icon @click="bookmark">
        <v-tooltip activator="parent" location="top">
          <p class="tooltip">ブックマーク</p>
        </v-tooltip>
        <v-icon class="bookmark-icon" color="grey-darken-3">mdi-bookmark-multiple-outline</v-icon>
      </v-btn>
    </div>
    <p v-if="status === 'playing'" class="red text-center mt-5">音読中</p>
    <p v-else-if="status === 'finished'" class="red text-center mt-5">結果</p>
    <!-- 英文 -->
    <v-card variant="outlined" :elevation="2" class="mx-auto mt-5 px-5 py-3">
      <v-card-text class="mt-3">
      <div class="sentence-body text-h6" v-html="sentence.body"></div>   
      </v-card-text>
    </v-card>
    <div v-if="status === 'unplayed'" class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="startReadAloud">音読開始</v-btn>
    </div>
    <div v-else-if="status === 'playing'" class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="stopReadAloud">音読を終了する</v-btn>
      <v-btn :border="true" @click="skipWord">パス</v-btn>
    </div>
    <div v-else class="mt-5">
      <div class="d-flex justify-center">
        <audio ref="audio"  controls></audio>
      </div>
      <div class="d-flex justify-center mt-5">
        <v-btn :border="true" @click="replayReadAloud">再音読する</v-btn>
        <v-btn v-if="progress2" class="" :border="true" :width="140">
          <v-progress-circular
            size="20"
            color="grey-darken-5"
            indeterminate
            width="3"
            class="progress2"
          ></v-progress-circular>
        </v-btn>
        <v-btn v-else-if="!isSavedVoice" :border="true" :width="140" @click="saveVoice">音声を保存する</v-btn>
        <v-btn v-else :border="true" :disabled="true" :width="140" class="voice-saved-btn">音声を保存しました</v-btn>
      </div>
    </div>
  </v-container>
  <!-- 要ログインモーダル -->
  <v-dialog v-model="loginRequiredDialog">
    <LoginRequiredModal @close-modal="closeLoginRequiredModal" />
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, Ref, reactive, onBeforeUnmount } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import { useUserStore } from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import LoginRequiredModal from "@/components/shared/LoginRequiredModal.vue"
import { toWords } from "number-to-words"

const flashStore = useFlashStore()
const userStore = useUserStore()

interface Props {
  id: string
}
interface Bookmark {
  userId: number
}

const props = defineProps<Props>()
const sentence = ref({
  id: "",
  title: "",
  body: ""
})
const bookmarkUserIds: Array<number> = reactive([])
const progress = ref(false)
const status: Ref<"unplayed" | "playing" | "finished"> = ref("unplayed")
let sentenceBodyBeforeReadAloud: string

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`sentences/${props.id}`)
    sentence.value = res.data.sentence
    res.data.sentence.bookmarks.forEach((bookmark: Bookmark) => bookmarkUserIds.push(bookmark.userId))
    sentenceBodyBeforeReadAloud = sentence.value.body
    sentence.value.body = setUpReadAloud(sentenceBodyBeforeReadAloud)
  } catch(e) {
    console.log(e)
  }
}
fetchSentence()

const animationProgress = () => {
  progress.value = true
  setTimeout(()=>{
    progress.value = false
  }, 450)
}

const bookmark = async (): Promise<void> => {
  if(!userStore.authUser){
    loginRequiredDialog.value = true
    return
  }
  try{
    await axios.post(`sentences/${props.id}/bookmark`)
    bookmarkUserIds.push(userStore.authUser!.id)
    animationProgress()
  } catch(e) {
    console.log(e)
  }
}

const unbookmark = async (): Promise<void> => {
  try{
    await axios.delete(`sentences/${props.id}/bookmark`)
    const index = bookmarkUserIds.indexOf(userStore.authUser!.id)
    bookmarkUserIds.splice(index, 1)
    animationProgress()
  } catch(e) {
    console.log(e)
  }
}

const loginRequiredDialog = ref(false)

const closeLoginRequiredModal = (): void => {
  loginRequiredDialog.value = false
}

/***************************************************
  音読機能
 ***************************************************/
let recognition: any
let results: Array<"succeeded" | "failed" | "symbol" | "ignored" | "ruby_waved">
let sentenceWords: Array<string>
let failedTimes: number
let numberWordPosition: number | null = null
let mediaRecorder: MediaRecorder;
let localStream: MediaStream;
const audio = ref<HTMLAudioElement>()
let trainingId: string
let voiceBlob: Blob
const progress2 = ref(false)
const isSavedVoice = ref(false)
let blob_url: string

//音読でタイピングゲームをするための準備を行う
const setUpReadAloud = (body: string): string => {
  //カンマ区切りの数値をカンマなし表記に置き換えた後、アポストロフィ以外の記号で分割する
  sentenceWords = body.replace(/(\d),(\d)/g,`$1$2`).split(/(\s|[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣])/g)
  //数値にルビを振る
  sentenceWords = sentenceWords.map((word: string) => {
    if(word && !/\s|[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣]/.test(word) && !isNaN(word as any)){
      return [`<ruby>${word}<rt>`,toWords(word).split(/(\s|[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣])/g), '</rt></ruby>'].flat()
    }
    return word
  }).flat()
  return sentenceWords.join('')
}

//音読スタート
const startReadAloud = (): void => {
  flashStore.$reset()
  flashStore.playReadAloud()
  status.value = "playing"
  playReadAloud()
}

//音読でタイピングゲーム
const playReadAloud = async (): Promise<void> => {
  failedTimes = 0
  results = []
  let isSucceeded = false

  const stream = await navigator.mediaDevices.getUserMedia({audio: true })
  localStream = stream
  mediaRecorder = new MediaRecorder(stream)
  mediaRecorder.start()

  const Recognition = window.webkitSpeechRecognition || window.SpeechRecognition
  recognition = new Recognition()
  recognition.lang = 'en-US'
  recognition.interimResults = true
  recognition.continuous = true
  recognition.onresult = (event) => {
    for (let i = 0; i < event.results.length; ++i) {
      if (event.results[i].isFinal) {
        //
      } else { 
        const result = event.results[i][0]
        if (!result) continue
        isSucceeded=false

        //数字を音声認識で文字起こした時、数値で文字起こしされるか英語表記で文字起こしされる。数値で文字起こしされた場合は英語表記に変換して判定することにする。
        const transcriptWords: Array<string> = result.transcript.split(' ').map((transcriptWord: string) => {
          const word = transcriptWord.replace(/(\d),(\d)/g,`$1$2`)
          if(word && !isNaN(word as any)){
            return toWords(word).split(/\s|-|,/)
          }
          return word
        }).flat()
        
        for(let j = 0; j < transcriptWords.length; j++){
          if(results.length < sentenceWords.length && wordMatchesDecision(sentenceWords[results.length], transcriptWords, j)){
            isSucceeded = true
            failedTimes = 0
            sentenceWords[results.length] = `<span class="gray">${sentenceWords[results.length]}</span>`
            sentence.value.body = sentenceWords.join('')
            results.push("succeeded")
            skipUpToWord()
          }
        }
        if(!isSucceeded){
          failedTimes++
        }
        if(results.length < sentenceWords.length && failedTimes > 5){
          failedTimes = 0
          sentenceWords[results.length] = `<span class="red">${sentenceWords[results.length]}</span>`
          sentence.value.body = sentenceWords.join('')
          results.push("failed")
        }
        skipUpToWord()
        if(results.length === sentenceWords.length){
          recognition.stop()
          break
        }
      }
    }
  }
  //音読終了後の処理
  recognition.onaudioend = (e1) =>{
    mediaRecorder.ondataavailable = (e2) => {
      if(audio.value){
        blob_url = window.URL.createObjectURL(e2.data)
        audio.value.src = blob_url
      }
      voiceBlob = e2.data
    }
    localStream.getTracks().forEach(track => track.stop())

    flashStore.$reset()
    flashStore.finishReadAloud()
    status.value = "finished"
    registerReadAloudResult()
  }

  recognition.start()
  skipUpToWord()
}

const wordMatchesDecision = (sentenceWord: string, transcriptWords: string[], index: number): boolean => {
  if(sentenceWord.toLowerCase() === transcriptWords[index].toLowerCase()){
    return true
  }

  //アポストロフィを含む場合の判定条件
  if(!sentenceWord.includes("'")){
    return false
  }
  if(!transcriptWords[index + 1]){
    return false
  }
  let apostropheWords: Array<string> = []
  let apostropheWords2: Array<string> = []
  if(sentenceWord.includes("'s")){
    apostropheWords = sentenceWord.replace("'s", " is").split(" ")
    apostropheWords2 = sentenceWord.replace("'s", " has").split(" ")
  }else if(sentenceWord.includes("'m")){
    apostropheWords = sentenceWord.replace("'m", " am").split(" ")
  }else if(sentenceWord.includes("'ll")){
    apostropheWords = sentenceWord.replace("'l", " will").split(" ")
  }else if(sentenceWord.includes("'d")){
    apostropheWords = sentenceWord.replace("'d", " would").split(" ")
  }else if(sentenceWord.includes("'ve")){
    apostropheWords = sentenceWord.replace("'ve", " have").split(" ")
  }else if(sentenceWord.includes("'re")){
    apostropheWords = sentenceWord.replace("'re", " are").split(" ")
  }

  if(apostropheWords[0].toLowerCase() === transcriptWords[index].toLowerCase() &&
    apostropheWords[1].toLowerCase() === transcriptWords[index + 1].toLowerCase() ){
      return true
  }
  if(apostropheWords2.length && 
    apostropheWords2[0].toLowerCase() === transcriptWords[index].toLowerCase() &&
    apostropheWords2[1].toLowerCase() === transcriptWords[index + 1].toLowerCase() ){
      return true
  }

  return false
}

//次の単語がセットされるまで記号、空白をスキップする
const skipUpToWord = (): void => {
  if(results.length === sentenceWords.length){
    return
  }

  //空白をスキップ
  if(sentenceWords[results.length] === "" || /\s/.test(sentenceWords[results.length])){
    results.push("ignored")
    skipUpToWord()
  //ルビを振られた数値をスキップ
  }else if(/<ruby>.+<rt>/.test(sentenceWords[results.length])){
    numberWordPosition = results.length
    results.push("ignored")
    skipUpToWord()
  //ルビ箇所の英文の音読が終了後、ルビを振られた数値をグレー色に変更する
  }else if(/<\/rt><\/ruby>/.test(sentenceWords[results.length])){
    if(!numberWordPosition) throw 'error'
    results[numberWordPosition] = "ruby_waved"
    sentenceWords[numberWordPosition] = sentenceWords[numberWordPosition].replace(/((?<=<ruby>).+(?=<rt>))/,`<span class="gray">$1</span>`)
    sentence.value.body = sentenceWords.join('')
    numberWordPosition = null
    results.push("ignored")
    skipUpToWord()
  //記号をスキップ
  }else if(/[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣]/.test(sentenceWords[results.length])){
    sentenceWords[results.length] = `<span class="gray">${sentenceWords[results.length]}</span>`
    sentence.value.body = sentenceWords.join('')
    results.push("symbol")
    skipUpToWord()
  }
}

//1単語パス機能
const skipWord = (): void => {
  failedTimes = 0
  sentenceWords[results.length] = `<span class="red">${sentenceWords[results.length]}</span>`
  sentence.value.body = sentenceWords.join('')
  results.push("failed")
  skipUpToWord()
  if(results.length === sentenceWords.length){
    recognition.stop()
  }
}

//音読終了
const stopReadAloud = (): void => {
  recognition.stop()
}

//再音読
const replayReadAloud = (): void => {
  sentence.value.body = setUpReadAloud(sentenceBodyBeforeReadAloud)
  startReadAloud()
}

//音読の結果をapiへ送信
const registerReadAloudResult = async (): Promise<void> => {
  if(!userStore.authUser) return

  const resultWords = results.map((result, index) => {
    return {
      position: index,
      result
    }
  })
  try{
    const res = await axios.post("user/trainings", {
      training: {
        sentence_id: props.id,
        result_words_attributes: resultWords
      }
    })
    trainingId = res.data.training.id
  } catch(e) {
    console.log(e)
  }
}

//音声をS3にダイレクトアップロード
const uploadVoiceToS3 = async (file: Blob): Promise<string | undefined> => {
  try{
    const res = await axios.get("user/voices/presigned_post")
    const formData = new FormData()
    for(let key in res.data.fields) {
      formData.append(key, res.data.fields[key])
    }
    formData.append('file', file)
    await Axios.post(res.data.url, formData, {
      headers: {
        'accept': 'multipart/form-data'
      }
    })
    return res.data.fields.key.replace(/.*\//, "")
  } catch(e) {
    console.log(e)
  }
}

const animationProgress2 = () => {
  progress2.value = true
  setTimeout(()=>{
    progress2.value = false
  }, 450)
}

//音声を保存
const saveVoice = async (): Promise<void> => {
  if(!userStore.authUser){
    loginRequiredDialog.value = true
    return
  }

  try{
    const name = await uploadVoiceToS3(voiceBlob)
    await axios.post("user/voices", {
      training_id: trainingId,
      voice: name
    })
    animationProgress2()
    isSavedVoice.value = true
  }catch(e){
    console.log(e)
  }
}

onBeforeUnmount(() => {
  if(mediaRecorder && mediaRecorder.state === "recording"){
    stopReadAloud()
  }
  if(blob_url){
    window.URL.revokeObjectURL(blob_url)
  }
})

</script>

<style scoped>
.sentence-body{
  font-weight: 350;
  line-height: 1.5;
}
.bookmark-btn{
  border: 1px solid gray;
  border-radius: 50%;
}
.bookmark-icon{

}
.tooltip{
  font-size: 12px;
  margin: -3px -10px;
  color: #fff;
}
.progress{
  margin: 9px;
}
.voice-saved-btn{
  font-size: 0.8rem;
}
</style>
<style>
rt{
  font-size: 1.15rem;
  padding: 0 10px;
}
.gray {
  color: gray;
  opacity: .7;
}
.red {
  color: red;
  opacity: .7;
}
</style>
