<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
    <v-card variant="outlined" :elevation="2" class="mx-auto mt-5 px-5 py-3">
      <v-card-text class="mt-3">
      <div class="sentence-body text-h6" v-html="sentence.body"></div>   
      </v-card-text>
    </v-card>
    <div v-if="isSavedVoice" class="d-flex justify-center">
      <audio ref="audio"  controls></audio>
    </div>
    <div class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="linkToSentence">この英文を音読する</v-btn>
      <v-btn :border="true">音声を再生する</v-btn>
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { ref, onBeforeUnmount } from "vue"
import axios from "@/plugins/axios"
import { useRouter } from 'vue-router'
import { toWords } from "number-to-words";

const router = useRouter()

interface Props {
  id: string
}
interface ResultWord {
  position: number
  result: "succeeded" | "failed" | "symbol" | "ignored" | "ruby_waved"
}

const props = defineProps<Props>()
const sentence = ref({
  id: "",
  title: "",
  body: ""
})
const isSavedVoice = ref(false)
const audio = ref<HTMLAudioElement>()
let blob_url: string

const decorateSentence = (body: string, resultWords: Array<ResultWord>): string => {
  const sentenceWords = body.replace(/(\d),(\d)/g,`$1$2`).split(/(\s|[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣])/g).map((word: string) => {
    if(word && !/\s|[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣]/.test(word) && !isNaN(word as any)){
      return [`<ruby>${word}<rt>`,toWords(word).split(/(\s|[ -&]|[(-/]|[:-@]|[[-`]|[{-~]|[｢｣])/g), '</rt></ruby>'].flat()
    }
    return word
  }).flat()

  for(let resultWord of resultWords){
    if(resultWord.result === "succeeded"){
      sentenceWords[resultWord.position] = `<span class="gray">${sentenceWords[resultWord.position]}</span>`
    }else if(resultWord.result === "failed"){
      sentenceWords[resultWord.position] = `<span class="red">${sentenceWords[resultWord.position]}</span>`
    }else if(resultWord.result === "symbol"){
      sentenceWords[resultWord.position] = `<span class="gray">${sentenceWords[resultWord.position]}</span>`      
    }else if(resultWord.result === "ruby_waved"){
      sentenceWords[resultWord.position] = sentenceWords[resultWord.position].replace(/((?<=<ruby>).+(?=<rt>))/,`<span class="gray">$1</span>`)  
    }
  }
  return sentenceWords.join('')
}

const fetchTraining = async (): Promise<void> => {
  try{
    const res = await axios.get(`user/trainings/${props.id}`)
    sentence.value = res.data.training.sentence
    sentence.value.body = decorateSentence(sentence.value.body, res.data.training.resultWords)
    await setAudio(res.data.training.voice)
  } catch(e) {
    console.log(e)
  }
}
fetchTraining()

const setAudio = async (name: string): Promise<void> => {
  if(!name) return

  isSavedVoice.value = true
  const res = await axios.get("user/voices/presign", {
    params: {
      name
    }
  })
  blob_url = res.data
  audio.value!.src = blob_url
}

const linkToSentence = (): void => {
  router.push({ name: "Sentence", params: { id: sentence.value.id } })
}

onBeforeUnmount(() => {
  window.URL.revokeObjectURL(blob_url)
})

</script>

<style scoped>
.sentence-body{
  font-weight: 350;
  line-height: 1.5;
}
</style>
