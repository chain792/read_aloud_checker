<template>
  <div>トップページです</div>
  <div>{{ store.hello }}</div>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="axiosTest">
    Secondary
  </v-btn>
</template>

<script setup lang="ts">
import { computed } from "vue"
import { useStore } from "../../store/store"
import { useDisplay } from "vuetify"
import axios from "../../plugins/axios"
const store = useStore()
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
    .get("api/v1/users")
    .then((res) => {
      console.log(res)
    })
    .catch((e) => {
      console.log(e)
    })
}
</script>

<style scoped></style>
