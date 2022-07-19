<template>
  <v-card width="400" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">ユーザー登録</v-card-title>
      <v-card-subtitle v-if="errorMessages.length" class="mt-3">
        <ErrorMessages :error-messages="errorMessages" />
      </v-card-subtitle>
    </v-card-item>
    <v-card-text class="mt-3">
      <v-form
        ref="form"
        v-model="valid"
        lazy-validation
      >
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

        <v-text-field
          v-model="user.email"
          type="email"
          label="メールアドレス"
          placeholder="メールアドレスを入力"
          color="blue"
          density="comfortable"
          variant="outlined"
          required
          :rules="emailRules"
        ></v-text-field>

        <v-text-field
          v-model="user.password"
          :type="isVisiblePassword ? 'text' : 'password'"
          label="パスワード"
          placeholder="半角英数字6文字以上"
          color="blue"
          density="comfortable"
          variant="outlined"
          :rules="passwordRules"
          required
          :append-inner-icon="isVisiblePassword ? 'mdi-eye' : 'mdi-eye-off'"
          @click:append-inner="isVisiblePassword = !isVisiblePassword"
        ></v-text-field>

        <v-btn
          :disabled="!valid"
          color="success"
          class="mr-4"
          width="400"
          @click="register"
        >
          登録
        </v-btn>

      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "../../plugins/axios"
import Axios from "axios"
import ErrorMessages from "../../components/shared/ErrorMessages.vue"
import { useUserStore }  from "../../store/userStore"
import { useFlashStore } from "../../store/flashStore"

const userStore = useUserStore()
const flashStore = useFlashStore()


const valid = ref(true)

const user = reactive({
  name: "",
  email: "",
  password: ""
})

const nameRules = [
  (v: string) => !!v || '名前を入力してください',
  (v: string) => (v && v.length <= 16) || '16文字以内で入力してください' 
]

const emailRules = [
  (v: string) => !!v || 'メールアドレスを入力してください',
  (v: string) => /.+@.+\..+/.test(v) || 'メールアドレスの形式が正しくありません',
]

const passwordRules = [
  (v: string) => !!v || 'パスワードを入力してください',
  (v: string) => (v && v.length >= 6) || '6文字以上で入力してください',
]
const isVisiblePassword = ref(false)


let errorMessages: string[] = reactive([])

const register = async (): Promise<void> => {
  try{
    errorMessages.splice(0)
    const res = await axios.post("users", { user: user })
    userStore.setUser(res.data)
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failSignup()
  }
}


</script>

<style scoped>
</style>
