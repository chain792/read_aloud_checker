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
        <v-btn :border="true" class="mx-auto" @click="profileDialog = true">プロフィール編集</v-btn>
      </div>
      <div class="d-flex justify-space-around mt-5">
        <p>メールアドレスを変更する</p>
        <p>パスワードを変更する</p>
      </div>
    </v-card-text>
  </v-card>

  <!-- プロフィール編集モーダル -->
  <v-dialog v-model="profileDialog">
    <v-card width="400" class="mx-auto mt-10 px-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">プロフィール編集</v-card-title>
        <v-card-subtitle v-if="errorMessages.length" class="mt-3">
          <ErrorMessages :error-messages="errorMessages" />
        </v-card-subtitle>
      </v-card-item>
      <v-card-text class="mt-3">
        <v-form
          ref="form"
          v-model="validProfile"
          lazy-validation
        >
          <div class="text-center">
            <img src="/public/cat.jpeg" alt="アバター" class="avatar">
          </div>
          <div class="mt-5">
            <v-text-field
              v-model="user.name"
              label="名前"
              placeholder="名前を入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="nameRules"
            ></v-text-field>
          </div>
          <div class="d-flex justify-space-around">
            <v-btn color="secondary" @click="profileDialog = false">キャンセル</v-btn>
            <v-btn
              :disabled="!validProfile"
              color="success"
              class="mr-4"
              @click="editProfile"
            >
              登録
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
// import axios from "@/plugins/axios"
// import Axios from "axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useUserStore } from "@/store/userStore"


const userStore = useUserStore()
const currentUser = userStore.authUser!
const errorMessages: string[] = reactive([])

const user = reactive({
  name: "",
  avatar: ""
})

const profileDialog = ref(false)
const validProfile = ref(true)
const nameRules = [
  (v: string) => !!v || '名前を入力してください',
  (v: string) => (v && v.length <= 16) || '16文字以内で入力してください' 
]

const editProfile = (): void => {

}


</script>

<style scoped>
.avatar{
  border-radius: 50%;
  width: 60px;
  height: 60px;
}
</style>
