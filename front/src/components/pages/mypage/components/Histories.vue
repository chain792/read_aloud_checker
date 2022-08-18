<template>
  <v-card v-for="history in histories" :key="history.id" class="my-3 mx-10">
    <router-link :to="{ name: 'History', params: { id: history.id } }" class="text-decoration-none">
      <v-card-text class="pb-2">
        <div>
          {{ history.title }}
        </div>
        <div class="d-flex">
          <v-icon
            size="small"
            color="grey-lighten-1"
            class="icon"
          >
            mdi-account-voice
          </v-icon>
          <p class="ml-1 voice-text">{{ history.wordCount }}</p>
          <p class="ml-3 date-text">{{ displayDate(history.createdAt) }}</p>
        </div>
      </v-card-text>
    </router-link>
  </v-card>
</template>

<script setup lang="ts">
import { reactive } from "vue"
import axios from "@/plugins/axios"
import { displayDate } from "@/common/datetime"

interface Sentence {
  id: string
  title: string
}
interface Training {
  id: string
  title: string
  sentence: Sentence
  createdAt: string
  wordCount: number
}
interface History {
  id: string
  title: string
  createdAt: string
  wordCount: number
}


const histories: Array<History> = reactive([])

const fetchTrainings = async (): Promise<void> => {
  try{
    const res = await axios.get("user/trainings")
    console.log(res)
    res.data.trainings.map((training: Training) => {
      histories.push({
        id: training.id,
        title: training.sentence.title,
        createdAt: training.createdAt,
        wordCount: training.wordCount
      })
    })
  } catch(e) {
    console.log(e)
  }
}
fetchTrainings()

</script>

<style scoped>
.icon{
  margin-top: 1px;
}
.voice-text{
  font-size: 12px;
  font-weight: lighter;
  color: rgb(100,100,100);
}
.date-text{
  letter-spacing: 0px;
  font-size: 12px;
  font-weight: lighter;
  color: rgb(100,100,100);
}
</style>
