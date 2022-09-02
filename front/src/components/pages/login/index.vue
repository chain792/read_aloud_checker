<template>
  <div class="page-login py-5 pt-sm-10">
    <v-card :width="cardWidth" class="mx-auto px-3 px-sm-5 py-3">
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
            v-if="progress"
            :disabled="true"
            color="warning"
            width="100%"
          >
            <v-progress-circular
              size="20"
              color="grey-darken-5"
              indeterminate
              width="3"
            ></v-progress-circular>
          </v-btn>
          <v-btn
            v-else
            :disabled="!valid"
            color="warning"
            width="100%"
            @click="login"
          >
            ログイン
          </v-btn>
          <div class="mt-2">
            <router-link :to="{ name: 'NewPasswordReset' }" class="link-text text-blue-accent-4">パスワードを忘れた場合はこちら</router-link>
          </div>
          <div class="mt-1">
            <router-link :to="{ name: 'Signup' }" class="link-text text-blue-accent-4">新規登録はこちら</router-link>
          </div>
          <p class="text-center text-border my-4">または</p>
          <v-btn
            prepend-icon="mdi-twitter" 
            class="text-capitalize twitter-btn"
            width="100%"
            @click="twitterLogin"
          >
            <span class="text-body-1 text-white">Twitterでログイン</span>
          </v-btn>
          <v-btn
            class="text-capitalize mt-3"
            border
            width="100%"
            @click="googleLogin"
          >
            <img src="/google_logo.svg" class="google-logo">
            <span class="text-body-1">Googleでログイン</span>
          </v-btn>
          
          <v-btn
            class="text-capitalize yahoo-btn mt-3"
            width="100%"
            @click="yahooLogin"
          >
            <img src="/yahoo_japan_icon_64.png" class="yahoo-logo">
            <div class="yahoo-text-container"><div class="text-body-1 yahoo-text">Yahooでログイン</div></div>
          </v-btn>

        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, ComputedRef } from "vue"
import axios from "@/plugins/axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useUserStore }  from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import { useTokenStore } from "@/store/tokenStore"
import { useRouter } from 'vue-router'
import { refresh } from "@/common/refresh"
import { useDisplay } from "vuetify"

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()
const router = useRouter()
const display = useDisplay()

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return 400
  }
})

const progress = ref(false)
const errorMessages: string[] = reactive([])
const valid = ref(true)
const isVisiblePassword = ref(false)
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

const login = async (): Promise<void> => {
  progress.value = true
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.post("login", loginInfo)
    userStore.setUser(res.data.user)
    tokenStore.setToken(res.data.token, res.data.expiredTime)
    flashStore.succeedLogin()
    router.push({ name: "Profile" })
  } catch(e) {
    flashStore.failLogin()
  }
  progress.value = false
}

/***************************************************
  ソーシャルログイン
 ***************************************************/
let windowLogin: Window | null
const twitterLogin = async (): Promise<void> => {
  flashStore.$reset()
  try{
    const res = await axios.get("oauth/twitter/new")
    windowLogin = window.open(res.data)
    setTimeout(CheckLoginStatus, 1000)
  } catch(e) {
    console.log(e)
    flashStore.failLogin()
  }
}

const googleLogin = async (): Promise<void> => {
  flashStore.$reset()
  try{
    const res = await axios.get("oauth/google/new")
    windowLogin = window.open(res.data)
    setTimeout(CheckLoginStatus, 1000)
  } catch(e) {
    console.log(e)
    flashStore.failLogin()
  }
}

const yahooLogin = async (): Promise<void> => {
  flashStore.$reset()
  try{
    const res = await axios.get("oauth/yahoo/new")
    windowLogin = window.open(res.data)
    setTimeout(CheckLoginStatus, 1000)
  } catch(e) {
    console.log(e)
    flashStore.failLogin()
  }
}

const CheckLoginStatus = async (): Promise<void> => {
  if (windowLogin!.closed) {
    const isLoginSucceed = await refresh()
    if(isLoginSucceed){
      flashStore.succeedLogin()
      router.push({ name: "Profile" })
    }else{
      flashStore.failLogin()
    }
  }
  else{
    setTimeout(CheckLoginStatus, 1000)
  }
}

</script>

<style scoped>
.page-login{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.text-border{
  display: flex;
  align-items: center;
}

.text-border::before,
.text-border::after {
  content: "";
  flex-grow: 1;
  height: 1px;
  background-color: #ccc;
}

.text-border::before {
  margin-right: 15px;
}

.text-border::after {
  margin-left: 15px;
}
</style>
