<template>
  <div class="page-edit-sentence py-5 pt-sm-10">
    <v-card :width="cardWidth" class="mx-auto px-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">英文編集</v-card-title>
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
            <div class="radio-label">公開・非公開設定</div>
            <v-radio
              label="公開する"
              value="public_state"
            ></v-radio>
            <v-radio
              label="公開しない"
              value="private_state"
            ></v-radio>
          </v-radio-group>

          <ProgressButton
            width="100%"
            color="warning"
            :progress="progress"
            :disabled="!valid"
            @click="updateSentences"
          >
            編集
          </ProgressButton>

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
import ProgressButton from "@/components/shared/ProgressButton.vue"

const flashStore = useFlashStore()
const router = useRouter()
const display = useDisplay()

interface Props {
  id: string
}

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value || display.sm.value) {
    return '100%'
  } else {
    return 800
  }
})

const props = defineProps<Props>()
const valid = ref(true)
const sentence = reactive({
  title: "",
  body: "",
  status: ""
})
const titleRules = [
  (v: string) => !!v || 'タイトルを入力してください',
  (v: string) => (v && v.length <= 100) || '100文字以内で入力してください' 
]
const bodyRules = [
  (v: string) => !!v || '本文を入力してください',
  (v: string) => (v && v.length <= 10000) || '10000文字以内で入力してください' 
]
const errorMessages: string[] = reactive([])
const progress = ref(false)

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`user/sentences/${props.id}/edit`)
    console.log(res)
    sentence.title = res.data.sentence.title
    sentence.body = res.data.sentence.body
    sentence.status = res.data.sentence.status
  } catch(e) {
    flashStore.invalidUrl()
    router.push({ name: "TopPage" })
  }
}
fetchSentence()

const updateSentences = async (): Promise<void> => {
  try{
    errorMessages.splice(0)
    progress.value = true
    await axios.patch(`user/sentences/${props.id}`, { sentence: sentence })
    flashStore.succeedUpdateSentences()
    router.push({ name: "MySentences" })
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    progress.value = false
    flashStore.failUpdateSentences()
  }
}

</script>

<style scoped>
.page-edit-sentence{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.radio-label{
  letter-spacing: 0.01em;
  color: #555;
}
</style>
