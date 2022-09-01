<template>
  <div class="page-user-sentences">
    <v-container>
      <tab-menu :tab="1"></tab-menu>
      <v-card v-for="sentence in sentences" :key="sentence.id" class="my-3 mx-10">
        <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
          <v-card-text>{{ sentence.title }}</v-card-text>
        </router-link>
      </v-card>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { reactive } from "vue"
import axios from "@/plugins/axios"
import TabMenu from "../components/TabMenu.vue"

interface Sentence {
  id: string
  title: string
}

const sentences: Array<Sentence> = reactive([])

const fetchSentences = async (): Promise<void> => {
  try{
    const res = await axios.get("user_sentences")
    console.log(res)
    res.data.sentences.map((sentence: Sentence) => {
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
.page-user-sentences{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

@media (min-width: 1920px) {
  .page-user-sentences{
    padding-left: 250px;
    padding-right: 250px;
  }
}
</style>
