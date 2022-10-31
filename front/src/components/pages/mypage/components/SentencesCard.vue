<template>
  <div class="card-container">
    <v-card v-for="sentence in sentences" :key="sentence.id" :rounded="0" class="py-1 mx-sm-10 sentences-card">
      <router-link :to="{ name: 'Sentence', params: { id: sentence.id } }" class="text-decoration-none">
        <div class="d-flex">
          <div class="thumbnail-container flex-shrink-0">
            <v-img :src="thumbnailUrl(sentence)" :cover="true" :aspect-ratio="1" ></v-img>
          </div>
          <v-card-text>
            <div class="sentence-title">{{ sentence.title }}</div>
            <div class="text-black mt-2 d-flex">
              {{ sentence.wordCount }} 単語
              <v-btn
                v-if="sentence.categories[0]"
                class="ml-3 bg-grey-lighten-2 category-button"
                :rounded="true"
                density="compact"
                :to="{ name: 'CategorySentences', query: { keyword: sentence.categories[0].name } }"
              >
                <span class="text-body-2">{{ sentence.categories[0].name }}</span>
              </v-btn>
            </div>
            <div class="text-grey-darken-3 mt-3 d-sm-flex">
              <div v-if="sentence.status==='public_state'"><v-icon color="green-darken-3">mdi-eye-outline</v-icon> 公開中の英文</div>
              <div v-else><v-icon color="grey-darken-3">mdi-eye-off-outline</v-icon> 非公開の英文</div>
              <div class="mt-3 mt-sm-0 ml-sm-3">{{ displayDate(sentence.createdAt) }}</div>
            </div>
          </v-card-text>
        </div>
      </router-link>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { Sentence } from "@/@types/model"
import { thumbnailUrl } from "@/common/imageUrl"
import { displayDate } from "@/common/datetime"

interface Props {
  sentences: Array<Sentence>
}
defineProps<Props>()


</script>

<style scoped>
.thumbnail-container{
  width: 100px;
  background-color: rgba(200, 200, 200, 0.1)
}
.sentences-card{
  height: 150px;
}
.card-container .sentences-card:nth-child(n + 2){
  border-top: 1.5px solid rgba(200,200,200,0.2);
}
.sentence-title:hover{
  text-decoration: underline;
}

@media (min-width: 600px) {
  .sentences-card{
    height: 120px;
  }
}

</style>
