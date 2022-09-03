<template>
  <div class="page-sentence">
    <v-container class="d-flex flex-column sentence-container">
      <h1 class="text-center text-h5 sentence-title">{{ sentence.title }}</h1>
      <div class="d-flex justify-end">

        <div v-if="writer">
          <v-btn 
            v-if="display.xs.value" 
            class="icon-btn mr-5" 
            elevation="0" 
            icon 
            :to="{ name: 'User', params: { id: writer.id } }"
          >
            <v-tooltip activator="parent" location="top">
              <p class="tooltip">プロフィールを見る</p>
            </v-tooltip>
            <img :src="imageUrl('avatar', writer)" class="avatar">
          </v-btn>
          <p v-else class="writer-name mr-5">
            作成者：
            <router-link :to="{ name: 'User', params: { id: writer.id } }" class="link-text text-blue-accent-4">{{ writer.name }}</router-link>
          </p>
        </div>
        
        <!-- 編集ボタン -->
        <v-btn 
          v-if="isMySentence" 
          class="icon-btn mr-5" 
          elevation="0" 
          icon 
          :to="{ name: 'EditSentence', params: { id: sentence.id } }"
        >
          <v-tooltip activator="parent" location="top">
            <p class="tooltip">英文を編集する</p>
          </v-tooltip>
          <v-icon color="grey-darken-3">mdi-square-edit-outline</v-icon>
        </v-btn>
        <!-- 削除ボタン -->
        <v-btn 
          v-if="isMySentence"
          class="icon-btn mr-5"
          elevation="0"
          icon
          @click="deleteConfirmModal = true"
        >
          <v-tooltip activator="parent" location="top">
            <p class="tooltip">英文を削除する</p>
          </v-tooltip>
          <v-icon color="grey-darken-3">mdi-trash-can-outline</v-icon>
        </v-btn>
        <!-- ブックマークボタン -->
        <div v-if="progress" class="mr-5 icon-btn">
          <v-progress-circular
            size="20"
            color="grey-darken-5"
            indeterminate
            width="3"
            class="progress"
          ></v-progress-circular>
        </div>
        <v-btn v-else-if="(bookmarkUserIds as any[]).includes(userStore.authUser?.id)" class="icon-btn mr-5" elevation="0" icon @click="unbookmark">
          <v-tooltip activator="parent" location="top">
            <p class="tooltip">ブックマーク解除</p>
          </v-tooltip>
          <v-icon color="grey-darken-3">mdi-bookmark-check</v-icon>
        </v-btn>
        <v-btn v-else class="icon-btn mr-5" elevation="0" icon @click="bookmark">
          <v-tooltip activator="parent" location="top">
            <p class="tooltip">ブックマーク</p>
          </v-tooltip>
          <v-icon color="grey-darken-3">mdi-bookmark-multiple-outline</v-icon>
        </v-btn>
      </div>
      <div style="height: 36px">
        <v-alert
          v-if="status === 'playing'"
          color="info"
          class="py-2 mx-auto"
          :closable="false"
          width="300"
          variant="tonal"
        >
          <p class="text-center text-body-2">音読中</p>
        </v-alert>
        <v-alert
          v-else-if="status === 'finished'"
          color="error"
          class="py-2 mx-auto"
          :closable="false"
          width="300"
          variant="tonal"
        >
          <p class="text-center text-body-2">音読終了</p>
        </v-alert>
      </div>
      <!-- 英文 -->
      <v-card variant="outlined" :elevation="2" class="bg-white mx-auto mt-4 px-sm-5 flex-shrink-1 overflow-y-auto">
        <v-card-text class="">
        <div class="sentence-body text-h6" v-html="sentenceBodyforReadAloud"></div>   
        </v-card-text>
      </v-card>
      <div v-if="status === 'unplayed'" class="mt-5 d-flex justify-center">
        <v-btn 
          width="300"
          color="warning" 
          @click="startReadAloud"
        >
          音読開始
        </v-btn>
      </div>
      <div v-else-if="status === 'playing'" class="mt-5 d-flex justify-center">
        <v-btn 
          width="200"
          class="mr-3"
          color="warning" 
          @click="stopReadAloud"
        >
          音読を終了する
        </v-btn>
        <v-btn 
          :border="true"
          class="ml-3"
          width="100"
          @click="skipWord"
        >
          パス
        </v-btn>
      </div>
      <div v-else class="mt-3">
        <div class="d-sm-flex justify-center">
          <div class="mr-0 mr-sm-1">
            <p class="text-body-2 text-center mb-1">音読した音声</p>
            <div class="text-center"><audio ref="audio" controls></audio></div>
          </div>
          <div class="ml-0 ml-sm-1 mt-2 mt-sm-0">
            <p class="text-body-2 text-center mb-1">お手本の音声</p>
            <div class="text-center"><audio :src="speechUrl(sentence, userStore.authUser)"  controls></audio></div>
          </div>
        </div>
        <div class="d-flex justify-center mt-5">
          <v-btn 
            width="150" 
            class="mr-3"
            color="warning" 
            @click="replayReadAloud"
          >
            再音読する
          </v-btn>
          <v-btn v-if="progress2" class="ml-3" :border="true" :width="150">
            <v-progress-circular
              size="20"
              color="grey-darken-5"
              indeterminate
              width="3"
              class="progress2"
            ></v-progress-circular>
          </v-btn>
          <v-btn v-else-if="!isSavedVoice" class="ml-3" :border="true" :width="150" @click="saveVoice">音声を保存する</v-btn>
          <v-btn v-else :border="true" :disabled="true" :width="150" class="voice-saved-btn ml-3">音声を保存しました</v-btn>
        </div>
      </div>
    </v-container>
  </div>
  <!-- 削除確認モーダル -->
  <v-dialog v-model="deleteConfirmModal">
    <v-card :width="modalWidth" class="mx-auto px-5 py-3">
    <v-card-item>
      <div class="d-flex">
        <v-card-title class="text-h6 mx-auto">英文を削除する</v-card-title>
      </div>
    </v-card-item>
    <v-card-text class="mt-3">
      <div class="text-center">
        英文を削除します。よろしいですか？
      </div> 
      <div class="d-flex justify-space-around mt-6">
        <v-btn 
          color="accent"
          @click="deleteConfirmModal = false">キャンセル
        </v-btn>
        <v-btn v-if="progress3" :disabled="true" color="error" width="100">
          <v-progress-circular
            size="20"
            color="grey-darken-5"
            indeterminate
            width="3"
            class="progress2"
          ></v-progress-circular>
        </v-btn>
        <v-btn
          v-else
          color="error"
          width="100"
          @click="deleteSentence"
        >
          削除
        </v-btn>
      </div>
    </v-card-text>
  </v-card>
  </v-dialog>
  <!-- 要ログインモーダル -->
  <v-dialog v-model="loginRequiredDialog">
    <LoginRequiredModal @close-modal="closeLoginRequiredModal" />
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, Ref, reactive, onBeforeUnmount, computed, ComputedRef } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import { useUserStore } from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import LoginRequiredModal from "@/components/shared/LoginRequiredModal.vue"
import { speechUrl } from "@/common/speechUrl"
import { toWords } from "number-to-words"
import { useRouter } from 'vue-router'
import { useDisplay } from "vuetify"
import { imageUrl } from "@/common/imageUrl"

const flashStore = useFlashStore()
const userStore = useUserStore()
const router = useRouter()
const display = useDisplay()

interface Props {
  id: string
}
interface Bookmark {
  userId: number
}
interface User {
  id: number
  name: string
  avatar: string
}

const modalWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return display.width.value
  } else {
    return 500
  }
})

const props = defineProps<Props>()
const sentence = ref({
  id: "",
  title: "",
  body: "",
  maleSpeech: "",
  femaleSpeech: "",
  createrType: "",
  createrId: "",
})
const writer: Ref<User | undefined>  = ref()
const bookmarkUserIds: Array<number> = reactive([])
const progress = ref(false)
const progress2 = ref(false)
const progress3 = ref(false)
const status: Ref<"unplayed" | "playing" | "finished"> = ref("unplayed")
const sentenceBodyforReadAloud = ref("")
const loginRequiredDialog = ref(false)
const deleteConfirmModal = ref(false)

const isMySentence: ComputedRef<boolean> = computed(() => {
  if(!userStore.authUser) return false

  return sentence.value.createrType === "User" && Number(sentence.value.createrId) === userStore.authUser.id
})

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`sentences/${props.id}`)
    sentence.value = res.data.sentence
    res.data.sentence.bookmarks.forEach((bookmark: Bookmark) => bookmarkUserIds.push(bookmark.userId))
    sentenceBodyforReadAloud.value = setUpReadAloud(sentence.value.body)
    writer.value = res.data.sentence.user
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

const deleteSentence = async (): Promise<void> => {
  progress3.value = true
  try{
    await axios.delete(`user/sentences/${props.id}`)
    flashStore.succeedDeleteSentence()
    router.push({ name: 'MySentences' })
  } catch(e) {
    console.log(e)
    flashStore.failDeleteSentence()
  }
  progress3.value = false
}


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
            sentenceBodyforReadAloud.value = sentenceWords.join('')
            results.push("succeeded")
            skipUpToWord()
          }
        }
        if(!isSucceeded){
          failedTimes++
        }
        if(results.length < sentenceWords.length && failedTimes > 10){
          failedTimes = 0
          sentenceWords[results.length] = `<span class="red">${sentenceWords[results.length]}</span>`
          sentenceBodyforReadAloud.value = sentenceWords.join('')
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
    sentenceBodyforReadAloud.value = sentenceWords.join('')
    numberWordPosition = null
    results.push("ignored")
    skipUpToWord()
  //記号をスキップ
  }else if(/[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣]/.test(sentenceWords[results.length])){
    sentenceWords[results.length] = `<span class="gray">${sentenceWords[results.length]}</span>`
    sentenceBodyforReadAloud.value = sentenceWords.join('')
    results.push("symbol")
    skipUpToWord()
  }
}

//1単語パス機能
const skipWord = (): void => {
  failedTimes = 0
  sentenceWords[results.length] = `<span class="red">${sentenceWords[results.length]}</span>`
  sentenceBodyforReadAloud.value = sentenceWords.join('')
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
  sentenceBodyforReadAloud.value = setUpReadAloud(sentence.value.body)
  isSavedVoice.value = false
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
        title: sentence.value.title,
        body: sentence.value.body,
        male_speech: sentence.value.maleSpeech,
        female_speech: sentence.value.femaleSpeech,
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

//音声を保存
const saveVoice = async (): Promise<void> => {
  if(!userStore.authUser){
    loginRequiredDialog.value = true
    return
  }

  try{
    progress2.value = true
    const name = await uploadVoiceToS3(voiceBlob)
    await axios.post("user/voices", {
      training_id: trainingId,
      voice: name
    })
    isSavedVoice.value = true
  }catch(e){
    console.log(e)
  }
  progress2.value = false
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

.page-sentence{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.sentence-container{
  height: calc(100vh - 64px) !important;
}

.sentence-title{
  font-size: 1.3rem !important;
}

.sentence-body{
  font-weight: 350;
  line-height: 1.5;
  font-size: 1.1rem !important;
}
.icon-btn{
  border: 1px solid gray;
  border-radius: 50%;
}

.avatar{
  border-radius: 50%;
  width: 40px;
  height: 40px;
}

.writer-name{
  font-size: 0.9rem;
  color: #333;
  margin: 10px 15px 0px -15px;
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
  font-size: 0.8rem !important;
}
@media (min-width: 600px) {
  .sentence-container{
    height: calc(100vh - 64px - 68px) !important;
  }
  .sentence-title{
    font-size: 1.5rem !important;
  }
  .sentence-body{
    font-size: 1.25rem !important;
  }
}

@media (min-width: 1920px) {
  .sentence-container{
    padding-left: 200px;
    padding-right: 200px;
  }
}
</style>
