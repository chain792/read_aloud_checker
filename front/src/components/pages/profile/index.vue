<template>
  <v-card width="600" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">プロフィール</v-card-title>
    </v-card-item>
    <v-card-text class="mt-3">
      <div class="text-center">
        <img :src="imageUrl('avatar', currentUser)" alt="アバター" class="avatar">
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
        <p  class="blue-text" @click="emailDialog = true">メールアドレスを変更する</p>
        <p  class="blue-text" @click="passwordDialog = true">パスワードを変更する</p>
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
              <img ref="preview" :src="imageUrl('avatar', user)" alt="アバター" class="avatar pointer" @click="changeAvatar">
              <v-icon class="icon" color="grey-lighten-4">
                mdi-camera-enhance-outline
              </v-icon>
            </div>
            <input ref="fileInput" type="file" accept="image/*" style="display: none;" @change="previewAvatar">
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

  <!-- メールアドレス変更モーダル -->
  <v-dialog v-model="emailDialog">
    <v-card width="400" class="mx-auto mt-10 px-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">メールアドレスの変更</v-card-title>
        <v-card-subtitle v-if="errorMessages.length" class="mt-3">
          <ErrorMessages :error-messages="errorMessages" />
        </v-card-subtitle>
      </v-card-item>
      <v-card-text class="mt-3">
        <v-form
          v-model="validEmail"
        >
          <div class="mt-5">
            <v-text-field
              v-model="emailFormValue"
              type="email"
              label="新しいメールアドレス"
              placeholder="新しいメールアドレスを入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="emailRules"
            ></v-text-field>
          </div>
          <div class="mt-5">
            <v-text-field
              v-model="passwordForChangeEmail"
              type="password"
              label="現在のパスワード"
              placeholder="現在のパスワードを入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="passwordRules"
            ></v-text-field>
          </div>
          <div class="d-flex justify-space-around">
            <v-btn color="success" @click="emailDialog = false">キャンセル</v-btn>
            <v-btn
              :disabled="!validEmail"
              color="success"
              class="mr-4"
              @click="updateEmail"
            >
              この内容で編集する
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>

  <!-- パスワード変更モーダル -->
  <v-dialog v-model="passwordDialog">
    <v-card width="400" class="mx-auto mt-10 px-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">パスワードの変更</v-card-title>
        <v-card-subtitle v-if="errorMessages.length" class="mt-3">
          <ErrorMessages :error-messages="errorMessages" />
        </v-card-subtitle>
      </v-card-item>
      <v-card-text class="mt-3">
        <v-form
          v-model="validPassword"
        >
          <div class="mt-5 mb-n4">
            <v-text-field
              v-model="currentPassword"
              type="password"
              label="現在のパスワード"
              placeholder="現在のパスワードを入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="passwordRules"
            ></v-text-field>
          </div>
          <v-divider class="mx-n10"></v-divider>
          <div class="mt-5">
            <v-text-field
              v-model="newPassword"
              type="password"
              label="新しいパスワード"
              placeholder="新しいパスワードを入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="passwordRules"
            ></v-text-field>
          </div>
          <div>
            <v-text-field
              v-model="newPasswordConfirmation"
              type="password"
              label="新しいパスワード（確認）"
              placeholder="新しいパスワード（確認）を入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="passwordRules"
            ></v-text-field>
          </div>
          <div class="d-flex justify-space-around">
            <v-btn color="success" @click="passwordDialog = false">キャンセル</v-btn>
            <v-btn
              :disabled="!validPassword"
              color="success"
              class="mr-4"
              @click="updatePassword"
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
import { imageUrl } from "@/common/imageUrl"


const userStore = useUserStore()
const flashStore = useFlashStore()
const currentUser = reactive(userStore.authUser!)
const errorMessages: string[] = reactive([])


/***************************************************
  プロフィール編集
 ***************************************************/
const user = reactive({
  id: 0,
  name: "",
  avatar: ""
})
user.id = currentUser.id
user.name = currentUser.name
user.avatar = currentUser.avatar

let uploadFile: File | null = null

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

const previewAvatar = (): void => {
  const file = fileInput.value!.files![0]
  const reader = new FileReader()
  reader.onloadend = (): void => {
    preview.value!.src = reader.result as string
  }
  if(file){
    reader.readAsDataURL(file)
    user.avatar = file.name
    uploadFile = file
  }
}

const uploadAvatarToS3 = async (file: File | null): Promise<void> => {
  if(!file) return
  console.log('a')
  try{
    const res = await axios.get("profile/presign", {
      params: {
        name: user.avatar
      }
    })
    const formData = new FormData()
    for(let key in res.data.fields) {
      formData.append(key, res.data.fields[key])
    }
    formData.append('file', file)
    await Axios.post(res.data.url, formData, {
      headers: {
        'accept': 'multipart/form-data'
      }
    })
  } catch(e) {
    console.log(e)
  }
}

const updateProfile = async (): Promise<void> => {
  flashStore.$reset()
  try{
    await uploadAvatarToS3(uploadFile)
    errorMessages.splice(0)
    const res = await axios.patch("profile", { user: user })
    userStore.setUser(res.data)
    flashStore.succeedUpdateProfile()
    currentUser.name = res.data.name
    currentUser.avatar = res.data.avatar
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

watch(profileDialog, () => {
  if(!profileDialog.value){
    user.name = currentUser.name
    user.avatar = currentUser.avatar
    uploadFile = null
  }
})

/***************************************************
  メールアドレス変更
 ***************************************************/
const emailDialog = ref(false)
const validEmail = ref(true)
const emailFormValue = ref('')
const passwordForChangeEmail = ref('')
const emailRules = [
  (v: string) => !!v || 'メールアドレスを入力してください',
  (v: string) => /.+@.+\..+/.test(v) || 'メールアドレスの形式が正しくありません',
]
const passwordRules = [
  (v: string) => !!v || 'パスワードを入力してください',
  (v: string) => (v && v.length >= 6) || '6文字以上で入力してください',
]

const updateEmail = async (): Promise<void> => {
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.patch("profile/email", {
      email: emailFormValue.value,
      password: passwordForChangeEmail.value
    })
    userStore.setUser(res.data)
    flashStore.succeedUpdateEmail()
    currentUser.email = res.data.email
    emailDialog.value = false
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failUpdateEmail()
  }
}

watch(emailDialog, () => {
  if(!emailDialog.value){
    emailFormValue.value = ''
    passwordForChangeEmail.value = ''
  }
})

/***************************************************
  パスワード変更
 ***************************************************/
const passwordDialog = ref(false)
const validPassword = ref(true)
const currentPassword = ref('')
const newPassword = ref('')
const newPasswordConfirmation = ref('')

const updatePassword = async (): Promise<void> => {
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.patch("profile/password", {
      current_password: currentPassword.value,
      password: newPassword.value,
      password_confirmation: newPasswordConfirmation.value
    })
    userStore.setUser(res.data)
    flashStore.succeedUpdatePassword()
    passwordDialog.value = false
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failUpdatePassword()
  }
}

watch(passwordDialog, () => {
  if(!passwordDialog.value){
    currentPassword.value = ''
    newPassword.value = ''
    newPasswordConfirmation.value = ''
  }
})

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

.blue-text{
  color: #0030ff;
  cursor: pointer;
  padding: 10px;
}


.blue-text:hover{
  text-decoration: underline;
}
</style>
