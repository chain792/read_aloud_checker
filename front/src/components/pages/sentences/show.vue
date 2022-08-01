<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
    <v-card variant="outlined" :elevation="2" class="mx-auto mt-5 px-5 py-3">
      <v-card-text class="mt-3">
      <div class="sentence-body text-h6" v-html="sentence.body"></div>   
      </v-card-text>
    </v-card>
    <div v-if="!isPlaying" class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="startReadAloud">音読開始</v-btn>
    </div>
    <div v-else class="mt-5 d-flex justify-center">
      <v-btn :border="true">音読を終了する</v-btn>
      <v-btn :border="true">パス</v-btn>
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from "vue"
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

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`sentences/${props.id}`)
    sentence.value = res.data
    //sentence.value.body = `<span class="red">aaa<span>`
  } catch(e) {
    console.log(e)
  }
}
fetchSentence()

const isPlaying = ref(false)
const startReadAloud = (): void => {
  isPlaying.value = true
  playReadAloud()
}

const playReadAloud = (): void => {
  const Recognition = window.webkitSpeechRecognition || window.SpeechRecognition;
  const sentenceWords = sentence.value.body.split(' ')
  let wordCount = 0
  let isSucceeded = false
  let failedTimes = 0
  const recognition = new Recognition();
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
          if(sentenceWords[wordCount].toLowerCase() === transcriptWords[j].toLowerCase()){
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
        if(failedTimes > 5){
          failedTimes = 0
          sentenceWords[wordCount] = `<span class="red">${sentenceWords[wordCount]}</span>`
          sentence.value.body = sentenceWords.join(' ')
          wordCount++
        }
      }
    }
  }
  recognition.onaudioend = (event) =>{
    console.log(event)
  }
  recognition.onspeechend = (event) =>{
    console.log(event)
  }

  recognition.start()
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
