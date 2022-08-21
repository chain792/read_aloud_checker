<template>
  <div>トップページです</div>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="axiosTest">
    Secondary
  </v-btn>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="start">
    start
  </v-btn>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="stop">
    stop
  </v-btn>
  <audio ref="audio" src="" controls></audio>

    <a id="download">Download</a>
  <button id="stop">Stop</button>
</template>

<script setup lang="ts">
import { computed, ref } from "vue"
import { useDisplay } from "vuetify"
import axios from "@/plugins/axios"
const display = useDisplay()
const a = computed(() => {
  if (display.md.value) {
    return "large"
  } else {
    return "small"
  }
})

const axiosTest = () => {
  axios
    .get("users")
    .then((res) => {
      console.log('success')
      console.log(res)
    })
    .catch((e) => {
      console.log('fail')
      console.log(e)
    })
}

</script>

<style scoped></style>
