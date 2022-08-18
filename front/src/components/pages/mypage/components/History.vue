<template>
  <v-card v-for="history in histories" :key="history.id" class="my-3 mx-10">
    <!--<router-link :to="{ name: 'Sentence', params: { id: history.id } }" class="text-decoration-none">-->
      <v-card-text>{{ history.title }}</v-card-text>
    <!--</router-link>-->
  </v-card>
</template>

<script setup lang="ts">
import { reactive } from "vue"
import axios from "@/plugins/axios"

interface Sentence {
  id: string
  title: string
}
interface Training {
  id: string
  title: string
  sentence: Sentence
}
interface History {
  id: string
  title: string
}


const histories: Array<History> = reactive([])

const fetchTrainings = async (): Promise<void> => {
  try{
    const res = await axios.get("user/trainings")
    console.log(res)
    res.data.trainings.map((training: Training) => {
      histories.push({
        id: training.id,
        title: training.sentence.title
      })
    })
  } catch(e) {
    console.log(e)
  }
}
fetchTrainings()

</script>

<style scoped>
</style>
