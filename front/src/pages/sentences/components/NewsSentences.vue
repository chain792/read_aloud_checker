<template>
  <v-card v-for="sentence in sentences" :key="sentence.id" class="my-3 mx-10">
    <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
      <v-card-text>{{ sentence.title }}</v-card-text>
    </router-link>
  </v-card>
</template>

<script setup lang="ts">
import { reactive } from "vue"
import axios from "../../../plugins/axios"


interface Sentence {
  id: string
  title: string
}

const sentences: Array<Sentence> = reactive([])

const fetchSentences = async (): Promise<void> => {
  try{
    const res = await axios.get("news_sentences")
    console.log(res)
    res.data.map((sentence: Sentence) => {
      sentences.push({
        id: sentence.id,
        title: sentence.title
      })
    })
  } catch(e) {
    console.log(e)
  }
}
fetchSentences()

</script>

<style scoped>
</style>
