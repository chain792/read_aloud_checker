<template>
  <v-card v-for="sentence in sentences" :key="sentence" class="my-3 mx-10">
    <v-card-text>{{ sentence.title }}</v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "../../../plugins/axios"


interface Sentence {
  title: string
}

const sentences: Array<Sentence> = reactive([])

const fetchSentences = async (): Promise<void> => {
  try{
    const res = await axios.get("sentences")
    console.log(res)
    res.data.map((sentence: Sentence) => {
      sentences.push({
        title: sentence.title
      })
    })
    // router.push({ name: "LoginIndex" })
  } catch(e) {
    console.log(e)
  }
}
fetchSentences()




</script>

<style scoped>
</style>
