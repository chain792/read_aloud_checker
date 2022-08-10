<template>
  <v-card width="600" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">プロフィール</v-card-title>
    </v-card-item>
    <v-card-text class="mt-3">
      <div class="text-center">
        <img src="/public/cat.jpeg" alt="アバター" class="avatar">
      </div>
      <div class="text-center mt-3">
        <p class="text-h6">名前</p>
        <p class="mt-1 text-body-1">{{ currentUser.name }}</p>
      </div>
      <div class="text-center mt-3">
        <p class="text-h6">メールアドレス</p>
        <p class="mt-1 text-body-1">{{ currentUser.email }}</p>
      </div>
      <div class="text-center mt-3">
        <v-btn :border="true" class="mx-auto">プロフィール編集</v-btn>
      </div>
      <div class="d-flex justify-space-around mt-5">
        <p>メールアドレスを変更する</p>
        <p>パスワードを変更する</p>
      </div>


    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"

import { useUserStore } from "@/store/userStore"


const userStore = useUserStore()
const currentUser = userStore.authUser!



</script>

<style scoped>
.avatar{
  border-radius: 50%;
  width: 55px;
  height: 55px;
}
</style>
