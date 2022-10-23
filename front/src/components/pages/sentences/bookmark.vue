<template>
  <div class="page-bookmark">
    <v-container>
      <div class="bookmark-container">
        <p class="text-h6 text-center mt-1 text-grey-darken-3 font-weight-bold tracking-widest">ブックマークした英文</p>
        <v-divider  length="250" thickness="2" class="mx-auto mt-2"></v-divider>
        <div v-if="sentences.length" class="mt-6">
          <v-card v-for="sentence in sentences" :key="sentence.id" class="my-3 mx-10">
            <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
              <v-card-text>{{ sentence.title }}</v-card-text>
            </router-link>
          </v-card>
        </div>
        <div v-else-if="isAxiosFinished" class="mt-10">
          <p class="text-center text-grey-darken-3 text-body-2 tracking-wide">ブックマークしている英文はありません</p>
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
    const res = await axios.get("sentences/bookmark" + query)
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
  isAxiosFinished.value = true
}
fetchSentences(queryValueOfPage)

const paginate = (page: number) => {
  router.push({ name: "BookmarkSentences", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string)
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

@media (min-width: 1920px) {
  .bookmark-container{
    margin: 0 200px;
  }
}
</style>
