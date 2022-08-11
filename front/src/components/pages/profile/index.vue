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
          ref="profileForm"
          v-model="validProfile"
        >
          <div class="text-center">
            <div class="editable-avatar">
              <img src="/public/cat.jpeg" ref="preview" alt="アバター" class="avatar pointer" @click="changeAvatar">
              <v-icon class="icon" color="grey-lighten-4">
                mdi-camera-enhance-outline
              </v-icon>
            </div>
            <input ref="fileInput" type="file" accept="image/*" style="display: none;" @change="updateAvatar">
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
            <v-btn color="success" @click="profileDialog = false">キャンセル</v-btn>
            <v-btn
              :disabled="!validProfile"
              color="success"
              class="mr-4"
              @click="updateProfile"
            >
              この内容で編集する
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, Ref } from "vue"

import axios from "@/plugins/axios"
import Axios from "axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useUserStore } from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"


const userStore = useUserStore()
const flashStore = useFlashStore()
const currentUser = reactive(userStore.authUser!)
const errorMessages: string[] = reactive([])

const user = reactive({
  name: "",
  avatar: ""
})
user.name = currentUser.name
user.avatar = currentUser.avatar

const profileForm: Ref<any> = ref(null)
const profileDialog = ref(false)
const validProfile = ref(true)
const nameRules = [
  (v: string) => !!v || '名前を入力してください',
  (v: string) => (v && v.length <= 16) || '16文字以内で入力してください' 
]
const fileInput = ref<HTMLInputElement>()
const preview = ref<HTMLImageElement>()

//プロフィールモーダルを出した時はvalidProfileがnullのため、validete()を実行しvalidProfileをtrueにさせる
watch(profileForm, () => {
  if(profileForm.value){
    profileForm.value.validate()
  }
})

const changeAvatar = (): void => {
  fileInput.value!.click()
}

const updateAvatar = (): void => {
  const file = fileInput.value!.files![0]
  const reader = new FileReader()
  reader.onloadend = (): void => {
    preview.value!.src = reader.result as string
  }
  if(file){
    reader.readAsDataURL(file)
  }
}

const updateProfile = async (): Promise<void> => {
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.patch("profile", { user: user })
    userStore.setUser(res.data)
    flashStore.succeedUpdateProfile()
    currentUser.name = res.data.name
    profileDialog.value = false
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failUpdateProfile()
  }
}

</script>

<style scoped>
.avatar{
  border-radius: 50%;
  width: 60px;
  height: 60px;
}

.pointer{
  cursor: pointer;
}

.editable-avatar{
  position: relative;
}

.icon{
  background-color: rgba(100,100,100,0.8);
  border-radius: 50%;
  padding: 16px;
  position: absolute;
  left: calc(50% - 16px);
  top: calc(50% - 18px);
  pointer-events: none;
}
</style>
