<template>
  <v-card width="400" class="mx-auto px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">パスワードの変更</v-card-title>
      <v-card-subtitle v-if="errorMessages.length" class="mt-3">
        <ErrorMessages :error-messages="errorMessages" />
      </v-card-subtitle>
    </v-card-item>
    <v-card-text class="mt-3">
      <v-form
        v-model="valid"
      >
        <v-divider class="mx-n10"></v-divider>
        <div class="mt-5">
          <v-text-field
            v-model="user.password"
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
            v-model="user.password_confirmation"
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
          <v-btn
            :disabled="!valid"
            color="success"
            class="mr-4"
            @click="resetPassword"
          >
            パスワード変更
          </v-btn>
        </div>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useFlashStore } from "@/store/flashStore"
import { useRouter } from 'vue-router'

interface Props {
  id: string
}

const props = defineProps<Props>()
const router = useRouter()

const flashStore = useFlashStore()
const errorMessages: string[] = reactive([])

const valid = ref(true)
const user = reactive({
  password: "",
  password_confirmation: ""
})
const passwordRules = [
  (v: string) => !!v || 'パスワードを入力してください',
  (v: string) => (v && v.length >= 6) || '6文字以上で入力してください',
]

const verifyToken = async (): Promise<void> => {
  flashStore.$reset()
  try{
    await axios.get(`password_resets/${props.id}/edit`)
  } catch(e) {
    flashStore.failVerifyToken()
    router.push({ name: "Login" })
  }
}
verifyToken()

const resetPassword = async (): Promise<void> => {
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    await axios.patch(`password_resets/${props.id}`, { user: user })
    flashStore.succeedResetPassword()
    router.push({ name: "Login" })
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failResetPassword()
  }
}

</script>

<style scoped>
</style>
