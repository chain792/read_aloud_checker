<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
    <v-card variant="outlined" :elevation="2" class="mx-auto mt-5 px-5 py-3">
      <v-card-text class="mt-3 text-h6 sentence-body">
        {{ sentence.body }}
      </v-card-text>
    </v-card>
    <div v-if="!isPlaying" class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="startReadAloud">音読開始</v-btn>
    </div>
    <div v-else class="mt-5 d-flex justify-center">
      <v-btn :border="true" @click="playReadAloud">音読を終了する</v-btn>
      <v-btn :border="true" @click="playReadAloud">パス</v-btn>
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from "vue"
import { useRoute } from "vue-router"
import axios from "@/plugins/axios"

interface Props {
  id: string
}

const props = defineProps<Props>()
const sentence = ref({
  id: "",
  title: "",
  body: ""
})

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`sentences/${props.id}`)
    sentence.value = res.data
  } catch(e) {
    console.log(e)
  }
}
fetchSentence()

const isPlaying = ref(false)
const startReadAloud = (): void => {
  isPlaying.value = true
  playReadAloud()
}

const playReadAloud = (): void => {
}



</script>

<style scoped>
.sentence-body{
  font-weight: 350;
  line-height: 1.5;
}
</style>
