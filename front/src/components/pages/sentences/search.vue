<template>
  <div class="page-bookmark">
    <v-container>
      <div class="bookmark-container">
        <div class="text-h6 text-center mt-1 text-grey-darken-3 font-weight-bold tracking-widest">検索： {{ route.query.keyword }}</div>
        <v-divider  length="300" thickness="2" class="mx-auto mt-2"></v-divider>
        <order-button
          class="mt-3"
          @order-by-created="orderByCreated"
          @order-by-popular="orderByPopular"
        ></order-button>
        <div v-if="sentences.length" class="mt-6">
          <sentences-card :sentences="sentences"></sentences-card>
        </div>
        <div v-else-if="isAxiosFinished" class="mt-6">
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
import qs from "qs"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { Sentence } from "@/@types/model"
import SentencesCard from "./components/SentencesCard.vue"
import OrderButton from "./components/OrderButton.vue"

const router = useRouter()
const route = useRoute()

const queryValueOfKeyword = route.query.keyword? route.query.keyword as string: undefined
const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const queryValueOfSort = route.query.sort? route.query.sort as string : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)

const sentences = ref<Array<Sentence>>([])
const isAxiosFinished = ref(false)

const fetchSentences = async (page?: string | number, keyword?: string, sort?: string): Promise<void> => {
  try{
    const res = await axios.get("sentences/searches", {
      params: {
        page,
        q: {
          title_cont: keyword
        },
        sort
      },
      paramsSerializer: params => {
        return qs.stringify(params)
      }
    })
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
  isAxiosFinished.value = true
}
fetchSentences(queryValueOfPage, queryValueOfKeyword, queryValueOfSort)

const paginate = (page: number) => {
  router.push({ 
    name: "SearchSentences", 
    query: { 
      page,
      keyword: route.query.keyword,
      sort: route.query.sort
    } 
  })
}

const orderByCreated = (): void => {
  page.value = 1
  router.push({ 
    name: "SearchSentences",
    query: { 
      keyword: route.query.keyword,
      sort: 'created'
    } 
  })
}

const orderByPopular = (): void => {
  page.value = 1
  router.push({ 
    name: "SearchSentences",
    query: { 
      keyword: route.query.keyword,
      sort: 'popular'
    } 
  })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string, to.query.keyword as string, to.query.sort as string)
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
