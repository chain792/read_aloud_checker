<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
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
    <div v-else class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="replayReadAloud">再音読する</v-btn>
      <v-btn :border="true">音声を保存する</v-btn>
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { ref, Ref } from "vue"
import axios from "@/plugins/axios"

interface Props {
  id: string
}

const props = defineProps<Props>()

const sentence = ref({
  id: "",
  title: "",
  body: ""
})

const status: Ref<"unplayed" | "playing" | "finished"> = ref("unplayed")

let sentenceBodyBeforeReadAloud: string

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`sentences/${props.id}`)
    sentence.value = res.data
    sentenceBodyBeforeReadAloud = sentence.value.body
  } catch(e) {
    console.log(e)
  }
}
fetchSentence()

const startReadAloud = (): void => {
  status.value = "playing"
  playReadAloud()
}

let recognition: any
let wordCount: number
let failedWords: Array<string>
let sentenceWords: Array<string>
let failedTimes: number
//音読でタイピングゲーム
const playReadAloud = (): void => {
  wordCount = 0
  failedTimes = 0
  failedWords = []

  const Recognition = window.webkitSpeechRecognition || window.SpeechRecognition;
  sentenceWords = sentenceBodyBeforeReadAloud.split(' ')
  let isSucceeded = false
  recognition = new Recognition();
  recognition.lang = 'en-US'
  recognition.interimResults = true;
  recognition.continuous = true;
  recognition.onresult = (event) => {
    for (let i = 0; i < event.results.length; ++i) {
      if (event.results[i].isFinal) {
        //
      } else { 
        const result = event.results[i][0]
        if (!result) continue

        const transcriptWords = result.transcript.split(' ')
        
        console.log(transcriptWords)
        isSucceeded=false
        for(let j = 0; j < transcriptWords.length; j++){
          if(wordCount < sentenceWords.length && sentenceWords[wordCount].toLowerCase() === transcriptWords[j].toLowerCase()){
            isSucceeded = true
            failedTimes = 0
            sentenceWords[wordCount] = `<span class="gray">${sentenceWords[wordCount]}</span>`
            sentence.value.body = sentenceWords.join(' ')
            wordCount++
          }
        }
        if(!isSucceeded){
          failedTimes++
        }
        if(wordCount < sentenceWords.length && failedTimes > 5){
          failedTimes = 0
          failedWords.push(sentenceWords[wordCount])
          sentenceWords[wordCount] = `<span class="red">${sentenceWords[wordCount]}</span>`
          sentence.value.body = sentenceWords.join(' ')
          wordCount++
        }
        if(wordCount === sentenceWords.length){
          recognition.stop()
          break
        }
      }
    }
  }
  recognition.onaudioend = (event) =>{
    status.value = "finished"
    console.log(event)
    registerReadAloudResult()
  }

  recognition.start()
}

const stopReadAloud = (): void => {
  recognition.stop()
}

const skipWord = (): void => {
  failedTimes = 0
  failedWords.push(sentenceWords[wordCount])
  sentenceWords[wordCount] = `<span class="red">${sentenceWords[wordCount]}</span>`
  sentence.value.body = sentenceWords.join(' ')
  wordCount++
  if(wordCount === sentenceWords.length){
    recognition.stop()
  }
}

const replayReadAloud = (): void => {
  sentence.value.body = sentenceBodyBeforeReadAloud
  status.value = "playing"
  playReadAloud()
}

const registerReadAloudResult = async (): Promise<void> => {
  const resultWord = failedWords.map((word: string) => {
    return {
      word
    }
  })
  try{
    const res = await axios.post("user/trainings", {
      training: {
        sentence_id: props.id,
        word_count: wordCount,
        result_words_attributes: resultWord
      }
    })
    console.log(res)
  } catch(e) {
    console.log(e)
  }
}

</script>

<style scoped>
.sentence-body{
  font-weight: 350;
  line-height: 1.5;
}
</style>
<style>
.gray {
  color: gray;
  opacity: .7;
}
.red {
  color: red;
  opacity: .7;
}
</style>
