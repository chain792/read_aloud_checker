<template>
  <div class="page-news-sentences">
    <v-container class="pt-0">
      <tab-menu :tab="0"></tab-menu>
      <v-card v-for="sentence in sentences" :key="sentence.id" class="my-3 mx-3 mx-sm-10" style="height: 100px;">
        <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
          <div class="d-flex">
            <div class="thumbnail-container flex-shrink-0">
              <v-img :src="thumbnailUrl(sentence)" :cover="true" :aspect-ratio="1" ></v-img>
            </div>
            <v-card-text>{{ sentence.title }}</v-card-text>
          </div>
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
import { ref } from "vue"
import axios from "@/plugins/axios"
import TabMenu from "../components/TabMenu.vue"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { Sentence } from "@/@types/model"
import { thumbnailUrl } from "@/common/imageUrl"

const router = useRouter()
const route = useRoute()

const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)

const sentences = ref<Array<Sentence>>([])

const fetchSentences = async (page?: string | number): Promise<void> => {
  try{
    const res = await axios.get("sentences", {
      params: {
        page,
        type: 'news'
      }
    })
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
}
fetchSentences(queryValueOfPage)


const paginate = (page: number) => {
  router.push({ name: "NewsSentences", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string)
})

</script>

<style scoped>
.page-news-sentences{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}
.thumbnail-container{
  width: 100px;
  background-color: rgba(200, 200, 200, 0.1)
}
@media (min-width: 1920px) {
  .page-news-sentences{
    padding-left: 250px;
    padding-right: 250px;
  }
}
</style>
