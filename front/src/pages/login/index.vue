<template>
  <v-card width="400" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">ログイン</v-card-title>
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
          v-model="loginInfo.email"
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
          v-model="loginInfo.password"
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
          @click="login"
        >
          ログイン
        </v-btn>

      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "../../plugins/axios"
import ErrorMessages from "../../components/shared/ErrorMessages.vue"
import { useUserStore }  from "../../store/userStore"
import { useFlashStore } from "../../store/flashStore"
import { useTokenStore } from "../../store/tokenStore"
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()
const router = useRouter()


const valid = ref(true)

const loginInfo = reactive({
  email: "",
  password: ""
})

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

const login = async (): Promise<void> => {
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.post("login", loginInfo)
    userStore.setUser(res.data.user)
    tokenStore.setToken(res.data.token, res.data.expiredTime)
    flashStore.succeedLogin()
    router.push({ name: "SentencesIndex" })
  } catch(e) {
    flashStore.failLogin()
  }
}


</script>

<style scoped>
</style>
