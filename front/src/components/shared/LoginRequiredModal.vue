<template>
  <v-card :width="cardWidth" class="mx-auto px-5 py-3">
    <v-card-item>
      <div class="d-flex">
        <v-card-title class="text-h6 ml-auto">ユーザー登録してみませんか？</v-card-title>
        <v-btn
          icon
          elevation="0"
          class="ml-auto"
          @click="close"
        >
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </div>
    </v-card-item>
    <v-card-text class="mt-3">
      <div class="text-center">
        この機能を利用するにはログインが必要です。
      </div> 
      <div class="d-flex justify-space-around mt-6">
        <v-btn color="warning" @click="linkToSignup">新規登録</v-btn>
        <v-btn
          color="warning"
          @click="linkToLogin"
        >
          ログイン
        </v-btn>
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
  import { computed, ComputedRef } from "vue"
import { useRouter } from 'vue-router'
import { useDisplay } from "vuetify"

interface Emits { 
  (e: "close-modal"): void  // eslint-disable-line no-unused-vars
}
const emit = defineEmits<Emits>()

const router = useRouter()
const display = useDisplay()

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return 500
  }
})

const linkToSignup = (): void => {
  router.push({ name: "Signup" })
}

const linkToLogin = (): void => {
  router.push({ name: "Login" })
}

const close = (): void => {
  emit("close-modal")
}

</script>

<style scoped>

</style>
