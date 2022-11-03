<template>
  <div class="page-user-sentences">
    <v-container class="pt-0">
      <tab-menu :tab="1"></tab-menu>
      <order-button
        @order-by-created="orderByCreated"
        @order-by-popular="orderByPopular"
      ></order-button>
      <sentences-card :sentences="sentences" class="mt-12"></sentences-card>
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
import { ref } from "vue"
import axios from "@/plugins/axios"
import TabMenu from "../components/TabMenu.vue"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { Sentence } from "@/@types/model"
import SentencesCard from "../components/SentencesCard.vue"
import OrderButton from "../components/OrderButton.vue"

const router = useRouter()
const route = useRoute()

const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const queryValueOfSort = route.query.sort? route.query.sort as string : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)

const sentences = ref<Array<Sentence>>([])

const fetchSentences = async (page?: string | number, sort?: string): Promise<void> => {
  try{
    const res = await axios.get("sentences", {
      params: {
        page,
        type: 'user',
        sort
      }
    })
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
}
fetchSentences(queryValueOfPage, queryValueOfSort)


const paginate = (page: number) => {
  router.push({ 
    name: "UserSentences",
    query: { 
      page,
      sort: route.query.sort
    } 
  })
}

const orderByCreated = (): void => {
  page.value = 1
  router.push({ 
    name: "UserSentences",
    query: { 
      sort: 'created'
    } 
  })
}

const orderByPopular = (): void => {
  page.value = 1
  router.push({ 
    name: "UserSentences",
    query: { 
      sort: 'popular'
    } 
  })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string, to.query.sort as string)
})

</script>

<style scoped>
.page-user-sentences{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.thumbnail-container{
  width: 100px;
  background-color: rgba(200, 200, 200, 0.1)
}
.sentences-card{
  height: 130px;
}
.card-container .sentences-card:nth-child(n + 2){
  border-top: 1.5px solid rgba(200,200,200,0.2);
}
.sentence-title:hover{
  text-decoration: underline;
}
@media (min-width: 600px) {
  .sentences-card{
    height: 100px;
  }
}

@media (min-width: 1920px) {
  .page-user-sentences{
    padding-left: 250px;
    padding-right: 250px;
  }
}
</style>
