<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
    <v-card variant="outlined" :elevation="2" class="mx-auto mt-5 px-5 py-3">
      <v-card-text class="mt-3">
      <div class="sentence-body text-h6" v-html="sentence.body"></div>   
      </v-card-text>
    </v-card>
    <div class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="linkToSentence">この英文を音読する</v-btn>
      <v-btn :border="true">音声を再生する</v-btn>
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from "vue"
import axios from "@/plugins/axios"
import { useRouter } from 'vue-router'

const router = useRouter()

interface Props {
  id: string
}
interface ResultWord {
  position: number
  result: "succeeded" | "failed"
}

const props = defineProps<Props>()
const sentence = ref({
  id: "",
  title: "",
  body: ""
})

const decorateSentence = (body: string, resultWords: Array<ResultWord>): string => {
  const sentenceWords = body.split(' ')
  for(let resultWord of resultWords){
    sentenceWords[resultWord.position] = resultWord.result === "succeeded" 
      ? `<span class="gray">${sentenceWords[resultWord.position]}</span>`
      : `<span class="red">${sentenceWords[resultWord.position]}</span>`
  }
  return sentenceWords.join(' ')
}

const fetchTraining = async (): Promise<void> => {
  try{
    const res = await axios.get(`user/trainings/${props.id}`)
    sentence.value = res.data.training.sentence
    sentence.value.body = decorateSentence(sentence.value.body, res.data.training.resultWords)
  } catch(e) {
    console.log(e)
  }
}
fetchTraining()

const linkToSentence = (): void => {
  router.push({ name: "Sentence", params: { id: sentence.value.id } })
}

</script>

<style scoped>
.sentence-body{
  font-weight: 350;
  line-height: 1.5;
}
</style>
