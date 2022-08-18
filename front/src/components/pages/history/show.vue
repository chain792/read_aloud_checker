<template>
  <v-container>
    <h1 class="text-center text-h5">{{ sentence.title }}</h1>
    <v-card variant="outlined" :elevation="2" class="mx-auto mt-5 px-5 py-3">
      <v-card-text class="mt-3">
      <div class="sentence-body text-h6" v-html="sentence.body"></div>   
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from "vue"
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

const fetchTraining = async (): Promise<void> => {
  try{
    const res = await axios.get(`user/trainings/${props.id}`)
    console.log(res.data.training)
    sentence.value = res.data.training.sentence
    res.data.training
  } catch(e) {
    console.log(e)
  }
}
fetchTraining()

</script>

<style scoped>
.sentence-body{
  font-weight: 350;
  line-height: 1.5;
}
</style>
