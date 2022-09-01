<template>
  <div class="page-history">
    <v-container class="d-flex flex-column sentence-container">
      <h1 class="text-center text-h5 sentence-title">{{ sentence.title }}</h1>
      <v-card variant="outlined" :elevation="2" class="bg-white mx-auto mt-4 px-sm-5 flex-shrink-1 overflow-y-auto">
        <v-card-text class="">
          <div class="sentence-body text-h6" v-html="sentence.body"></div>   
        </v-card-text>
      </v-card>
        <div class="d-sm-flex justify-center mt-3">
          <div v-if="isSavedVoice" class="mr-0 mr-sm-1">
            <p class="text-body-2 text-center mb-1">音読した音声</p>
            <div class="text-center"><audio ref="audio" controls></audio></div>
          </div>
          <div class="ml-0 ml-sm-1 mt-2 mt-sm-0">
            <p class="text-body-2 text-center mb-1">お手本の音声</p>
            <div class="text-center"><audio :src="speechUrl(sentence, userStore.authUser)"  controls></audio></div>
          </div>
        </div>
      <div class="mt-5 d-flex justify-center">
        <v-btn 
          color="warning"
          width="300"
          @click="linkToSentence"
        >
          この英文を音読する
        </v-btn>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref, onBeforeUnmount } from "vue"
import axios from "@/plugins/axios"
import { useRouter } from 'vue-router'
import { toWords } from "number-to-words"
import { speechUrl } from "@/common/speechUrl"
import { useUserStore } from "@/store/userStore"

const router = useRouter()
const userStore = useUserStore()

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
  body: "",
  maleSpeech: "",
  femaleSpeech: "",
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
    sentence.value.id = res.data.training.sentenceId
    sentence.value.title = res.data.training.title
    sentence.value.maleSpeech = res.data.training.maleSpeech
    sentence.value.femaleSpeech = res.data.training.femaleSpeech
    sentence.value.body = decorateSentence(res.data.training.body, res.data.training.resultWords)
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
.page-history{
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
