<template>
  <div>
    {{ sentence.title }}
  </div>
  <div>
    {{ sentence.body }}
  </div>
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


</script>

<style scoped>
</style>
