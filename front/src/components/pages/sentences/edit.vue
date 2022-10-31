<template>
  <div class="page-edit-sentence py-5 pt-sm-10">
    <v-card :width="responsiveWidth800" class="mx-auto px-5 py-3">
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
          <BaseTextField
            v-model="editedSentence.title"
            label="タイトル"
            placeholder="英文のタイトルを入力"
            required
            :rules="titleRules"
          ></BaseTextField>

          <v-textarea
            v-model="editedSentence.body"
            label="本文"
            placeholder="本文を入力"
            color="blue"
            density="comfortable"
            variant="outlined"
            required
            :rules="bodyRules"
          ></v-textarea>

          <v-radio-group v-model="editedSentence.status">
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
            <ThumbnailForm 
              :image-src="previewThumbnailUrl(sentence)"
              @file-change="setThumbnailFile"
            >
            </ThumbnailForm>

            <div class="mt-5">
              <span class="text-caption text-grey-darken-3">タグを設定することができます</span>
              <AutoComplimentTextField
                v-model="editedSentence.category"
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
import { previewThumbnailUrl } from "@/common/imageUrl"
import { Sentence } from "@/@types/model"

const flashStore = useFlashStore()
const router = useRouter()

interface Props {
  id: string
}

const props = defineProps<Props>()
const valid = ref(true)
const sentence = ref<Sentence>()
const editedSentence = reactive({
  title: "",
  body: "",
  status: "",
  category: "",
})
let thumbnailFile: File | null | "" = null
const categories = ref<Array<string>>([])
const errorMessages: string[] = reactive([])
const progress = ref(false)

const fetchSentence = async (): Promise<void> => {
  try{
    const res = await axios.get(`user/sentences/${props.id}/edit`)
    sentence.value = res.data.sentence
    editedSentence.title = res.data.sentence.title
    editedSentence.body = res.data.sentence.body
    editedSentence.status = res.data.sentence.status
    if(res.data.sentence.categories[0]){
      editedSentence.category = res.data.sentence.categories[0].name
    }
  } catch(e) {
    flashStore.invalidUrl()
    router.push({ name: "TopPage" })
  }
}
fetchSentence()

const fetchCategories = async (): Promise<void> => {
  if(!editedSentence.category){
    categories.value = []
    return
  }

  try{
    const res = await axios.get("categories", {
      params: {
        word: editedSentence.category
      }
    })
    categories.value = res.data
  } catch(e) {
    console.log(e)
  }
}

const autoCompliment = (item: string) =>{
  editedSentence.category = item
}

const setThumbnailFile = (file: File | "") => {
  thumbnailFile = file
}

const updateSentences = async (): Promise<void> => {
  try{
    errorMessages.splice(0)
    progress.value = true
    const formData = new FormData()
    formData.append('sentence[title]', editedSentence.title)
    formData.append('sentence[body]', editedSentence.body)
    formData.append('sentence[status]', editedSentence.status)
    formData.append('sentence[category]', editedSentence.category)
    if(thumbnailFile !== null){
      formData.append('sentence[thumbnail]', thumbnailFile)
    }
    await axios.patch(`user/sentences/${props.id}`, formData)
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
