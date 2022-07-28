<template>
  <v-card width="800" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">英文投稿</v-card-title>
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
          v-model="sentence.title"
          label="タイトル"
          placeholder="英文のタイトルを入力"
          color="blue"
          density="comfortable"
          variant="outlined"
          required
          :rules="titleRules"
        ></v-text-field>

        <v-textarea
          v-model="sentence.body"
          label="本文"
          placeholder="本文を入力"
          color="blue"
          density="comfortable"
          variant="outlined"
          required
          :rules="bodyRules"
        ></v-textarea>

        <v-radio-group v-model="sentence.status">
          <v-radio
            label="公開する"
            :value="0"
          ></v-radio>
          <v-radio
            label="公開しない"
            :value="1"
          ></v-radio>
        </v-radio-group>

        <v-btn
          :disabled="!valid"
          color="success"
          class="mr-4"
          width="800"
          @click="createSentences"
        >
          投稿
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
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const flashStore = useFlashStore()
const router = useRouter()


const valid = ref(true)

const sentence = reactive({
  title: "",
  body: "",
  status: 0
})

const titleRules = [
  (v: string) => !!v || 'タイトルを入力してください',
  (v: string) => (v && v.length <= 100) || '100文字以内で入力してください' 
]

const bodyRules = [
  (v: string) => !!v || '本文を入力してください',
  (v: string) => (v && v.length <= 10000) || '10000文字以内で入力してください' 
]



let errorMessages: string[] = reactive([])

const createSentences = async (): Promise<void> => {
  try{
    errorMessages.splice(0)
    const res = await axios.post("sentences", { sentence: sentence })
    console.log(res)
    // userStore.setUser(res.data)
    // flashStore.succeedSignup()
    // router.push({ name: "LoginIndex" })
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    //lashStore.failSignup()
  }
}


</script>

<style scoped>
</style>
