<template>
  <div class="page-new-passwardreset py-5 pt-sm-10">
    <v-card :width="cardWidth" class="mx-auto px-3 px-sm-5 py-3">
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
import { ref, computed, ComputedRef } from "vue"
import axios from "@/plugins/axios"
import { useFlashStore } from "@/store/flashStore"
import { useRouter } from 'vue-router'
import { useDisplay } from "vuetify"

const flashStore = useFlashStore()
const router = useRouter()
const display = useDisplay()

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return 600
  }
})

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
.page-new-passwardreset{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}
</style>
