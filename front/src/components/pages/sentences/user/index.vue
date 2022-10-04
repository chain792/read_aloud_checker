<template>
  <div class="page-user-sentences">
    <v-container class="pt-0">
      <tab-menu :tab="1"></tab-menu>
      <v-card v-for="sentence in sentences" :key="sentence.id" class="my-3 mx-10">
        <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
          <v-card-text>{{ sentence.title }}</v-card-text>
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
import TabMenu from "../components/TabMenu.vue"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"

interface Sentence {
  id: string
  title: string
}

const router = useRouter()
const route = useRoute()

const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)

const sentences: Array<Sentence> = reactive([])

const fetchSentences = async (page?: string | number): Promise<void> => {
  try{
    const res = await axios.get("sentences", {
      params: {
        page,
        type: 'user'
      }
    })
    paginationLength.value= res.data.pagination.pages
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
fetchSentences(queryValueOfPage)


const paginate = (page: number) => {
  router.push({ name: "UserSentences", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  sentences.splice(0)
  await fetchSentences(to.query.page as string)
})

</script>

<style scoped>
.page-user-sentences{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

@media (min-width: 1920px) {
  .page-user-sentences{
    padding-left: 250px;
    padding-right: 250px;
  }
}
</style>
