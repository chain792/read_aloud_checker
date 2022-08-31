<template>
  <div class="page-mysentences">
    <v-container>
      <v-btn
        color="warning"
        class="mx-auto mt-3 mb-8"
        prepend-icon="mdi-plus-thick"
        width="300px"
        :to="{ name: 'NewSentence' }"
      >
        英文を作成する
      </v-btn>
      <div class="sentences-container">
        <v-card v-for="sentence in sentences" :key="sentence.id" class="my-3 mx-10">
          <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
            <v-card-text>{{ sentence.title }}</v-card-text>
          </router-link>
        </v-card>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { reactive } from "vue"
import axios from "@/plugins/axios"


interface Sentence {
  id: string
  title: string
}

const sentences: Array<Sentence> = reactive([])

const fetchSentences = async (): Promise<void> => {
  try{
    const res = await axios.get("user/sentences")
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
.page-mysentences {
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

@media (min-width: 1920px) {
  .sentences-container{
    margin: 0 200px;
  }
}
</style>
