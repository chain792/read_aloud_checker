<template>
  <div class="page-new-passwordreset py-5 pt-sm-10">
    <v-card :width="responsiveWidth600" class="mx-auto px-3 px-sm-5 py-3">
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
          <EmailTextField
            v-model="email"
            label="メールアドレス"
            placeholder="メールアドレスを入力"
            class="mt-5"
          ></EmailTextField>

          <v-btn
            :disabled="!valid"
            color="warning"
            class="mr-4"
            width="100%"
            @click="sendEmail"
          >
            メール送信
          </v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import axios from "@/plugins/axios"
import { useFlashStore } from "@/store/flashStore"
import { useRouter } from 'vue-router'
import { responsiveWidth600 } from "@/common/width"
import EmailTextField from "@/components/shared/form/EmailTextField.vue"

const flashStore = useFlashStore()
const router = useRouter()

const valid = ref(true)
const email = ref("")

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
.page-new-passwordreset{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}
</style>
