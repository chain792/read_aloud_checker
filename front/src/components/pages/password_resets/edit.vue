<template>
  <div class="page-edit-passwordreset py-5 pt-sm-10">
    <v-card :width="cardWidth" class="mx-auto px-3 px-sm-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">パスワード再設定</v-card-title>
        <v-card-subtitle v-if="errorMessages.length" class="mt-3">
          <ErrorMessages :error-messages="errorMessages" />
        </v-card-subtitle>
      </v-card-item>
      <v-card-text class="">
        <v-form
          v-model="valid"
        >
          <v-divider class="mx-n10"></v-divider>
          <div class="mt-6">新しいパスワードを入力してください</div>
          <div class="mt-6">
            <v-text-field
              v-model="user.password"
              type="password"
              label="新しいパスワード"
              placeholder="半角英数字6文字以上"
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
              placeholder="半角英数字6文字以上"
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
              color="warning"
              width="100%"
              @click="resetPassword"
            >
              パスワード再設定
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, ComputedRef } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useFlashStore } from "@/store/flashStore"
import { useRouter } from 'vue-router'
import { useDisplay } from "vuetify"


interface Props {
  id: string
}

const props = defineProps<Props>()
const router = useRouter()
const display = useDisplay()
const flashStore = useFlashStore()
const errorMessages: string[] = reactive([])

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return 400
  }
})

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
.page-edit-passwordreset{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}
</style>
