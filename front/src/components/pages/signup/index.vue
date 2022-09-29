<template>
  <div class="page-signup py-5 pt-sm-10">
    <v-card :width="responsiveWidth400" class="mx-auto px-3 px-sm-5 py-3">
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
          <BaseTextField
            v-model="user.name"
            label="名前"
            placeholder="名前を入力"
            required
            :rules="nameRules"
          ></BaseTextField>

          <EmailTextField
            v-model="user.email"
            label="メールアドレス"
            placeholder="メールアドレスを入力"
          ></EmailTextField>

          <PasswordTextField
            v-model="user.password"
            label="パスワード"
            placeholder="半角英数字6文字以上"
          ></PasswordTextField>

          <ProgressButton
            width="100%"
            color="warning"
            :progress="progress"
            :disabled="!valid"
            @click="register"
          >
            登録
          </ProgressButton>

          <div class="mt-2">
            <router-link :to="{ name: 'Login' }" class="link-text text-blue-accent-4">アカウントをお持ちの方はこちら</router-link>
          </div>
          <p class="text-center text-border my-4">または</p>
          <v-btn
            prepend-icon="mdi-twitter" 
            class="text-capitalize twitter-btn"
            width="100%"
            @click="twitterLogin"
          >
            <span class="text-body-1 text-white">Twitterで新規登録</span>
          </v-btn>
          <v-btn
            class="text-capitalize mt-3"
            border
            width="100%"
            @click="googleLogin"
          >
            <img src="/google_logo.svg" class="google-logo">
            <span class="text-body-1">Googleで新規登録</span>
          </v-btn>
          
          <v-btn
            class="text-capitalize yahoo-btn mt-3"
            width="100%"
            @click="yahooLogin"
          >
            <img src="/yahoo_japan_icon_64.png" class="yahoo-logo">
            <div class="yahoo-text-container"><div class="text-body-1 yahoo-text">Yahooで新規登録</div></div>
          </v-btn>

        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useUserStore }  from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import { useTokenStore } from "@/store/tokenStore"
import { useRouter } from 'vue-router'
import { refresh } from "@/common/refresh"
import ProgressButton from "@/components/shared/ProgressButton.vue"
import { responsiveWidth400 } from "@/common/width"
import EmailTextField from "@/components/shared/form/EmailTextField.vue"
import PasswordTextField from "@/components/shared/form/PasswordTextField.vue"
import { nameRules } from "@/common/rules"
import BaseTextField from "@/components/shared/form/BaseTextField.vue"

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()
const router = useRouter()

const progress = ref(false)
const valid = ref(true)

const user = reactive({
  name: "",
  email: "",
  password: ""
})


const errorMessages: string[] = reactive([])

const register = async (): Promise<void> => {
  progress.value = true
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.post("users", { user: user })
    userStore.setUser(res.data.user)
    tokenStore.setToken(res.data.token, res.data.expiredTime)
    flashStore.succeedSignup()
    router.push({ name: "Profile" })
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failSignup()
    progress.value = false
  }
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
.page-signup{
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
