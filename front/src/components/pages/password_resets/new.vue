<template>
  <v-card width="600" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">パスワード再設定のご案内</v-card-title>
    </v-card-item>
    <v-card-text class="mt-3">
      <v-form
        ref="form"
        v-model="valid"
        lazy-validation
      >
        <div>
          ご登録いただいたメールアドレスを入力してください。<br>
          ご登録メールアドレス宛てに、再設定ページの案内をお送りします。
        </div>
        <v-text-field
          v-model="email"
          type="email"
          label="メールアドレス"
          placeholder="メールアドレスを入力"
          color="blue"
          density="comfortable"
          variant="outlined"
          required
          :rules="emailRules"
          class="mt-5"
        ></v-text-field>

        <v-btn
          :disabled="!valid"
          color="success"
          class="mr-4"
          width="600"
          @click="sendEmail"
        >
          メール送信
        </v-btn>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref } from "vue"
import axios from "@/plugins/axios"
import { useFlashStore } from "@/store/flashStore"
import { useRouter } from 'vue-router'

const flashStore = useFlashStore()
const router = useRouter()

const valid = ref(true)
const email = ref("")
const emailRules = [
  (v: string) => !!v || 'メールアドレスを入力してください',
  (v: string) => /.+@.+\..+/.test(v) || 'メールアドレスの形式が正しくありません',
]

const sendEmail = async (): Promise<void> => {
  flashStore.$reset()
  try{
    await axios.post("password_resets", {
      email: email.value
    })
  } catch(e) {
    console.log(e)
  }
  router.push({ name: "PasswordResetSent" })
}

</script>

<style scoped>
</style>
