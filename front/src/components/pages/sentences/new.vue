<template>
  <div class="page-new-sentence py-5 pt-sm-10">
    <v-card :width="responsiveWidth800" class="mx-auto px-5 py-3">
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
          <BaseTextField
            v-model="sentence.title"
            label="タイトル"
            placeholder="英文のタイトルを入力"
            required
            :rules="titleRules"
          ></BaseTextField>

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

          <AccordionMenu>
            <ThumbnailForm @file-change="setThumbnailFile">
            </ThumbnailForm>

            <div class="mt-5">
              <span class="text-caption text-grey-darken-3">タグを設定することができます</span>
              <AutoComplimentTextField
                v-model="sentence.category"
                label="タグ"
                :items="categories"
                @input="fetchCategories"
                @auto-compliment="autoCompliment"
              >
              </AutoComplimentTextField>
            </div>
          </AccordionMenu>

          <ProgressButton
            width="100%"
            color="warning"
            :progress="progress"
            :disabled="!valid"
            @click="createSentences"
          >
            投稿
          </ProgressButton>

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
import { useFlashStore } from "@/store/flashStore"
import { useRouter } from 'vue-router'
import ProgressButton from "@/components/shared/ProgressButton.vue"
import { responsiveWidth800 } from "@/common/width"
import { bodyRules, titleRules } from "@/common/rules"
import BaseTextField from "@/components/shared/form/BaseTextField.vue"
import AutoComplimentTextField from "@/components/shared/form/AutoComplimentTextField.vue"
import AccordionMenu from "./components/AccordionMenu.vue"
import ThumbnailForm from "./components/ThumbnailForm.vue"

const flashStore = useFlashStore()
const router = useRouter()
const valid = ref(true)
const sentence = reactive({
  title: "",
  body: "",
  status: 'public_state',
  category: ""
})
let thumbnailFile: File | null | "" = null
const errorMessages: string[] = reactive([])
const progress = ref(false)
const categories = ref<Array<string>>([])

const fetchCategories = async (): Promise<void> => {
  if(!sentence.category){
    categories.value = []
    return
  }

  try{
    const res = await axios.get("categories", {
      params: {
        word: sentence.category
      }
    })
    categories.value = res.data
  } catch(e) {
    console.log(e)
  }
}

const autoCompliment = (item: string) =>{
  sentence.category = item
}

const setThumbnailFile = (file: File | "") => {
  thumbnailFile = file
}

const createSentences = async (): Promise<void> => {
  try{
    errorMessages.splice(0)
    progress.value = true
    const formData = new FormData()
    formData.append('sentence[title]', sentence.title)
    formData.append('sentence[body]', sentence.body)
    formData.append('sentence[status]', sentence.status)
    formData.append('sentence[category]', sentence.category)
    if(thumbnailFile){
      formData.append('sentence[thumbnail]', thumbnailFile)
    }
    await axios.post("user/sentences", formData)
    flashStore.succeedCreateSentences()
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
    flashStore.failCreateSentences()
  }
}

</script>

<style scoped>
.page-new-sentence{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.radio-label{
  letter-spacing: 0.01em;
  color: #555;
}

</style>
