<template>
  <div class="page-mysentences">
    <v-container>
      <p class="text-h6 text-center mt-1 text-grey-darken-3 font-weight-bold tracking-widest">作成した英文</p>
      <v-divider  length="250" thickness="2" class="mx-auto mt-2"></v-divider>
      <v-btn
        color="warning"
        class="mx-auto mt-5 mb-8"
        prepend-icon="mdi-plus-thick"
        width="300px"
        :to="{ name: 'NewSentence' }"
      >
        英文を作成する
      </v-btn>
      <div v-if="sentences.length" class="sentences-container">
        <sentences-card :sentences="sentences" class="mt-10"></sentences-card>
        <v-pagination
          v-if="paginationLength > 1"
          v-model="page"
          class="mt-4 mb-2"
          :length="paginationLength"
          @update:model-value="paginate(page as number)"
        ></v-pagination>
      </div>
      <div v-else-if="isAxiosFinished" class="mt-10">
        <p class="text-center text-grey-darken-3 text-body-2 tracking-wide">作成した英文はありません</p>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import axios from "@/plugins/axios"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { Sentence } from "@/@types/model"
import SentencesCard from "../components/SentencesCard.vue"

const router = useRouter()
const route = useRoute()

const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)

const sentences = ref<Array<Sentence>>([])
const isAxiosFinished = ref(false)

const fetchSentences = async (page?: string | number): Promise<void> => {
  try{
    const query =  page? `?page=${page}` : ''
    const res = await axios.get("user/sentences" + query)
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
  isAxiosFinished.value = true
}
fetchSentences(queryValueOfPage)

const paginate = (page: number) => {
  router.push({ name: "MySentences", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string)
})


</script>

<style scoped>
.page-mysentences {
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.tracking-wide{
  letter-spacing: 0.05em !important;
}

.tracking-widest{
  letter-spacing: 0.2em !important;
}

@media (min-width: 1920px) {
  .sentences-container{
    margin: 0 200px;
  }
}
</style>
