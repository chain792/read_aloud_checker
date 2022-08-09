<template>
  <div>トップページです</div>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="axiosTest">
    Secondary
  </v-btn>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="axiosTest2">
    localに送信
  </v-btn>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" to="/test">
    test
  </v-btn>
</template>

<script setup lang="ts">
import { computed } from "vue"
import { useDisplay } from "vuetify"
import axios from "@/plugins/axios"
import daxios from "axios"
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

const axiosTest2 = () => {
  daxios
    .get("http://localhost:8000/api/v1/users")
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
