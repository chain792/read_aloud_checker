<template>
  <div class="page-profile py-5 pt-sm-10">
    <v-card :width="cardWidth" class="mx-auto px-3 px-sm-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">プロフィール</v-card-title>
      </v-card-item>
      <v-card-text class="mt-3">
        <div class="text-center">
          <img :src="imageUrl('avatar', currentUser)" alt="アバター" class="avatar">
        </div>
        <div class="text-center mt-3">
          <p class="text-subtitle-1 fs-small text-grey-darken-3">名前</p>
          <v-divider length="42" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
          <p class="mt-2 text-body-1 fs-large">{{ currentUser.name }}</p>
        </div>
        <div class="text-center mt-4">
          <p class="text-subtitle-1 fs-small text-grey-darken-3">メールアドレス</p>
          <v-divider length="110" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
          <p class="mt-2 text-body-1">{{ currentUser.email }}</p>
        </div>
        <div class="text-center mt-5">
          <v-btn 
            color="warning"
            class="mx-auto"
            @click="profileDialog = true"
          >
            プロフィール編集
          </v-btn>
        </div>
        <div class="d-sm-flex justify-space-around mt-5">
          <p  class="change-profile-text text-blue-accent-4 text-center mt-3" @click="emailDialog = true">メールアドレスを変更する</p>
          <p  class="change-profile-text text-blue-accent-4 text-center mt-3" @click="passwordDialog = true">パスワードを変更する</p>
        </div>
      </v-card-text>
    </v-card>
  </div>

  <!-- プロフィール編集モーダル -->
  <v-dialog v-model="profileDialog">
    <v-card :width="modalWidth" class="mt-n10 px-5 py-3">
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
              <div class="d-inline-block">
                <v-tooltip activator="parent" location="top">
                  <p class="tooltip">画像を追加</p>
                </v-tooltip>
                <img ref="preview" :src="imageUrl('avatar', user)" alt="アバター" class="avatar pointer" @click="clickFileInput">
                <v-icon class="icon" color="grey-lighten-4">
                  mdi-camera-enhance-outline
                </v-icon>
              </div>
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
          <div class="d-sm-flex justify-space-around">
            <v-btn 
              color="accent" 
              :width="buttonWidth" 
              @click="profileDialog = false"
            >
              キャンセル
            </v-btn>
            <v-btn
              :disabled="!validProfile"
              color="warning"
              :width="buttonWidth"
              class="ml-sm-3 mt-3 mt-sm-0"
              @click="updateProfile"
            >
              この内容で編集する
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>

  <!-- トリミングダイアログ -->
  <v-dialog v-model="trimmingDialog">
    <v-card :width="trimedmodalWidth" class="mt-n10 px-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">画像の切り抜き</v-card-title>
      </v-card-item>
      <v-card-text class="mt-3">
        <div class="img-container">
          <v-row no-gutters>
            <v-col cols="12" sm="8">
              <vue-cropper 
                ref="cropper" 
                :src="cropperSrc"
                :aspect-ratio="1"
                preview=".crop-preview"
              />
            </v-col>
            <v-col cols="12" sm="4" class="mt-3 mt-sm-0">
              <p class="text-center  text-subtitle-1">プレビュー</p>
              <div class="mx-auto ml-sm-3 crop-preview"></div>
            </v-col>
          </v-row>
        </div>
        <div class="d-flex justify-center mt-5">
          <v-btn
            color="accent" 
            width="120" 
            class="mr-5"
            @click="trimmingDialog = false"
          >
            キャンセル
          </v-btn>
          <v-btn
            color="warning"
            width="100" 
            class="ml-5"
            @click="trimming"
          >
            適用
          </v-btn>
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>

  <!-- メールアドレス変更モーダル -->
  <v-dialog v-model="emailDialog">
    <v-card :width="modalWidth" class="mt-n10 px-5 py-3">
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
          <div>
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
          <div class="d-sm-flex justify-space-around">
            <v-btn 
              color="accent"
              :width="buttonWidth" 
              @click="emailDialog = false"
            >
              キャンセル
            </v-btn>
            <v-btn
              :disabled="!validEmail"
              color="warning"
              :width="buttonWidth" 
              class="ml-sm-3 mt-3 mt-sm-0"
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
    <v-card :width="modalWidth" class="mt-n10 px-5 py-3">
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
              :type="isVisiblePassword ? 'text' : 'password'"
              label="新しいパスワード"
              placeholder="半角英数字6文字以上"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="passwordRules"
              :append-inner-icon="isVisiblePassword ? 'mdi-eye' : 'mdi-eye-off'"
              @click:append-inner="isVisiblePassword = !isVisiblePassword"
            ></v-text-field>
          </div>
          <div>
            <v-text-field
              v-model="newPasswordConfirmation"
              type="password"
              label="新しいパスワード（確認）"
              placeholder="半角英数字6文字以上"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="passwordRules"
            ></v-text-field>
          </div>
          <div class="d-sm-flex justify-space-around">
            <v-btn 
              color="accent"
              :width="buttonWidth"
              @click="passwordDialog = false"
            >
              キャンセル
            </v-btn>
            <v-btn
              :disabled="!validPassword"
              color="warning"
              :width="buttonWidth"
              class="ml-sm-3 mt-3 mt-sm-0"
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
import { ref, reactive, watch, Ref, computed, ComputedRef } from "vue"

import axios from "@/plugins/axios"
import Axios from "axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useUserStore } from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import { imageUrl } from "@/common/imageUrl"
import { useDisplay } from "vuetify"
import VueCropper from 'vue-cropperjs';
import 'cropperjs/dist/cropper.css';


const userStore = useUserStore()
const flashStore = useFlashStore()
const currentUser = reactive(userStore.authUser!)
const errorMessages: string[] = reactive([])
const display = useDisplay()

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return 600
  }
})

const modalWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return display.width.value
  } else {
    return 400
  }
})

const trimedmodalWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return display.width.value
  } else {
    return 600
  }
})

const buttonWidth: ComputedRef<string | number | undefined> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return undefined
  }
})


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

let trimmedBlob: Blob | null = null
let uploadFileName: string = ""


const profileForm: Ref<any> = ref(null)
const profileDialog = ref(false)
const validProfile = ref(true)
const nameRules = [
  (v: string) => !!v || '名前を入力してください',
  (v: string) => (v && v.length <= 50) || '50文字以内で入力してください' 
]
const fileInput = ref<HTMLInputElement>()
const preview = ref<HTMLImageElement>()
const cropper = ref<any>()
const cropperSrc: Ref<string> = ref("")
const trimmingDialog = ref(false)


//プロフィールモーダルを出した時はvalidProfileがnullのため、validete()を実行しvalidProfileをtrueにさせる
watch(profileForm, () => {
  if(profileForm.value){
    profileForm.value.validate()
  }
})

const clickFileInput = (): void => {
  fileInput.value!.click()
}

const previewAvatar = (): void => {
  const file = fileInput.value!.files![0]
  const reader = new FileReader()
  reader.onloadend = (): void => {
    cropperSrc.value = reader.result as string
    trimmingDialog.value = true
  }
  if(file){
    reader.readAsDataURL(file)
    uploadFileName = file.name
  }
}

const trimming = (): void => {
  const canvas = cropper.value.getCroppedCanvas({
    width: 60,
		height: 60,
  }) as HTMLCanvasElement;
  canvas.toBlob((blob) => {
    if(!blob) return

    setTrimmedAvatar(blob)
    trimmingDialog.value = false
  })
}

const setTrimmedAvatar = (blob: Blob): void => {
  const file = blob
  const reader = new FileReader()
  reader.onloadend = (): void => {
    preview.value!.src = reader.result as string
  }
  if(file){
    reader.readAsDataURL(file)
    user.avatar = uploadFileName
    trimmedBlob = file
  }
}

const uploadAvatarToS3 = async (file: Blob | null): Promise<void> => {
  if(!file) return

  try{
    const res = await axios.get("profile/presigned_post", {
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
    await uploadAvatarToS3(trimmedBlob)
    errorMessages.splice(0)
    const res = await axios.patch("profile", { user: user })
    userStore.setUser(res.data.user)
    flashStore.succeedUpdateProfile()
    currentUser.name = res.data.user.name
    currentUser.avatar = res.data.user.avatar
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
    trimmedBlob = null
  }
})

watch(trimmingDialog, () => {
  if(!trimmingDialog.value){
    if(fileInput.value){
      fileInput.value.value = ""
    }
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
    userStore.setUser(res.data.user)
    flashStore.succeedUpdateEmail()
    currentUser.email = res.data.user.email
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
const isVisiblePassword = ref(false)

const updatePassword = async (): Promise<void> => {
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.patch("profile/password", {
      current_password: currentPassword.value,
      password: newPassword.value,
      password_confirmation: newPasswordConfirmation.value
    })
    userStore.setUser(res.data.user)
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
.page-profile{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

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

.change-profile-text{
  cursor: pointer;
}

.change-profile-text:hover{
  text-decoration: underline;
}

.crop-preview {
  overflow: hidden;
  width: 160px; 
  height: 160px;
  border: 1px solid red;
}

.tooltip{
  font-size: 12px;
  margin: -3px -10px;
  color: #fff;
}
.fs-large{
  font-size: 1.25rem !important;
}
.fs-small{
  font-size: 0.9rem !important;
}
</style>
