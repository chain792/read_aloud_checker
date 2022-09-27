<template>
  <div class="page-admin-login">
    <FlashMessage />
    <v-card :width="responsiveWidth400" class="mx-auto card-position px-3 px-sm-5 py-3">
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
          <EmailTextField
            v-model="loginInfo.email"
            label="メールアドレス"
            placeholder="メールアドレスを入力"
          ></EmailTextField>

          <PasswordTextField
            v-model="loginInfo.password"
            label="パスワード"
            placeholder="半角英数字6文字以上"
          ></PasswordTextField>

          <ProgressButton
            width="100%"
            color="warning"
            :progress="progress"
            :disabled="!valid"
            @click="login"
          >
            ログイン
          </ProgressButton>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "@/plugins/axios"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import { useUserStore }  from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import { useTokenStore } from "@/store/tokenStore"
import { useRouter } from 'vue-router'
import FlashMessage from '@/components/shared/FlashMessage.vue'
import ProgressButton from "@/components/shared/ProgressButton.vue"
import { responsiveWidth400 } from "@/common/width"
import EmailTextField from "@/components/shared/form/EmailTextField.vue"
import PasswordTextField from "@/components/shared/form/PasswordTextField.vue"

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()
const router = useRouter()

const progress = ref(false)
const errorMessages: string[] = reactive([])
const valid = ref(true)
const loginInfo = reactive({
  email: "",
  password: ""
})

const login = async (): Promise<void> => {
  progress.value = true
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.post("admin/login", loginInfo)
    userStore.setUser(res.data.user)
    tokenStore.setToken(res.data.token, res.data.expiredTime)
    flashStore.succeedLogin()
    router.push({ name: "AdminTopPage" })
  } catch(e) {
    flashStore.failLogin()
  }
  progress.value = false
}

</script>

<style scoped>
.page-admin-login{
  background-color: rgba(10, 10, 10, 0.2);
  height: 100%;
}

.card-position{
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  margin: auto;
  height: 310px;
}
</style>
