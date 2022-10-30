<template>
  <div class="page-bookmark">
    <v-container class="pt-0">
      <div class="bookmark-container">
        <div class="text-center">
          <div class="text-h6 px-5 py-2 title tracking-widest">[{{ route.query.keyword }}]の英文</div>
        </div>
        <div v-if="sentences.length" class="mt-10">
          <sentences-card :sentences="sentences"></sentences-card>
        </div>
        <div v-else-if="isAxiosFinished" class="mt-10">
          <p class="text-center text-grey-darken-3 text-body-2 tracking-wide">{{ route.query.keyword }}の英文はありません</p>
        </div>
        <v-pagination
          v-if="paginationLength > 1"
          v-model="page"
          class="mt-4 mb-2"
          :length="paginationLength"
          @update:model-value="paginate(page as number)"
        ></v-pagination>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import axios from "@/plugins/axios"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { Sentence } from "@/@types/model"
import SentencesCard from "./components/SentencesCard.vue"

const router = useRouter()
const route = useRoute()

const queryValueOfKeyword = route.query.keyword? route.query.keyword as string: undefined
const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)

const sentences = ref<Array<Sentence>>([])
const isAxiosFinished = ref(false)

const fetchSentences = async (page?: string | number, keyword?: string): Promise<void> => {
  try{
    const res = await axios.get("sentences/category", {
      params: {
        page,
        keyword
      },
    })
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
  isAxiosFinished.value = true
}
fetchSentences(queryValueOfPage, queryValueOfKeyword)

const paginate = (page: number) => {
  router.push({ 
    name: "CategorySentences", 
    query: { 
      page,
      keyword: route.query.keyword,
    } 
  })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string, to.query.keyword as string)
})


</script>

<style scoped>
.page-bookmark {
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.tracking-wide{
  letter-spacing: 0.05em !important;
}

.tracking-widest{
  letter-spacing: 0.2em !important;
}

.title {
  background-color: #fb901d;
  color: #fff;
  font-weight: 500;
  display: inline-block
}

@media (min-width: 1920px) {
  .bookmark-container{
    margin: 0 200px;
  }
}
</style>
