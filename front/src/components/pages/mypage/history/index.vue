<template>
  <div class="page-myhistory">
    <v-container class="pt-0">
      <tab-menu :tab="1"></tab-menu>
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
              <v-icon
                v-if="history.voice"
                size="small"
                color="orange-darken-2"
                class="icon ml-3"
              >
                mdi-microphone
              </v-icon>
            </div>
          </v-card-text>
        </router-link>
      </v-card>
      <v-pagination
        v-if="paginationLength > 1"
        v-model="page"
        class="mt-4 mb-2"
        :length="paginationLength"
        @update:model-value="paginate(page as number)"
      ></v-pagination>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "@/plugins/axios"
import { displayDate } from "@/common/datetime"
import TabMenu from "../components/TabMenu.vue"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"

interface Sentence {
  id: string
  title: string
}
interface Training {
  id: string
  title: string
  sentence: Sentence
  voice: string
  createdAt: string
  resultWords: Array<ResultWord>
}
interface History {
  id: string
  title: string
  voice: string
  createdAt: string
  wordCount: number
}
interface ResultWord {
  position: number
  result: "succeeded" | "failed"
}

const router = useRouter()
const route = useRoute()

const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)
const histories: Array<History> = reactive([])

const fetchTrainings = async (page?: string | number): Promise<void> => {
  try{
    const query =  page? `?page=${page}` : ''
    const res = await axios.get("user/trainings" + query)
    paginationLength.value= res.data.pagination.pages
    res.data.trainings.map((training: Training) => {
      histories.push({
        id: training.id,
        title: training.title,
        createdAt: training.createdAt,
        voice: training.voice,
        wordCount: training.resultWords.filter(resultWord => resultWord.result === "succeeded").length
      })
    })
  } catch(e) {
    console.log(e)
  }
}
fetchTrainings(queryValueOfPage)

const paginate = (page: number) => {
  router.push({ name: "MyHistory", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  histories.splice(0)
  await fetchTrainings(to.query.page as string)
})

</script>

<style scoped>
.page-myhistory{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}
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

@media (min-width: 1920px) {
  .page-myhistory{
    padding-left: 250px;
    padding-right: 250px;
  }
}
</style>
