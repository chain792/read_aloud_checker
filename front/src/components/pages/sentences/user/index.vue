<template>
  <div class="page-user-sentences">
    <v-container class="pt-0">
      <tab-menu :tab="1"></tab-menu>
      <div class="card-container mt-12">
        <v-card v-for="sentence in sentences" :key="sentence.id" :rounded="0" class="py-1 mx-sm-10 sentences-card">
          <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
            <div class="d-flex">
              <div class="thumbnail-container flex-shrink-0">
                <v-img :src="thumbnailUrl(sentence)" :cover="true" :aspect-ratio="1" ></v-img>
              </div>
              <v-card-text>
                <div>{{ sentence.title }}</div>
                <div class="text-black mt-2 d-flex">
                  {{ sentence.wordCount }} 単語
                  <v-btn
                    v-if="sentence.categories[0]"
                    class="ml-3 bg-grey-lighten-2 category-button"
                    :rounded="true"
                    density="compact"
                  >
                    <span class="text-body-2">{{ sentence.categories[0].name }}</span>
                  </v-btn>
                </div>
              </v-card-text>
            </div>
          </router-link>
        </v-card>
      </div>
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
        type: 'user'
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
  router.push({ name: "UserSentences", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string)
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
