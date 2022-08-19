<template>
  <v-card width="500" class="mx-auto px-5 py-3">
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
        <v-btn color="success" @click="linkToSignup">新規登録</v-btn>
        <v-btn
          color="success"
          class="mr-4"
          @click="linkToLogin"
        >
          ログイン
        </v-btn>
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

interface Emits { 
  (e: "close-modal"): void  // eslint-disable-line no-unused-vars
}
const emit = defineEmits<Emits>()

const router = useRouter()

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
