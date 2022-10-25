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

          <div class="accordion mb-5">
            <span 
              class="accordion-title py-2 pr-3"
              @click="isAccordion = !isAccordion"
            >  
              <span class="text-grey-darken-2" :class="{'open': isAccordion === true}">▼</span> 
              
              その他の設定
            </span>
            <div v-show="isAccordion" class="accordion-menu mt-2">
              <div>
                英文の画像イメージを追加する
              </div>
              <div>
                カテゴリー
              </div>
            </div>
          </div>

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

const flashStore = useFlashStore()
const router = useRouter()

const valid = ref(true)
const sentence = reactive({
  title: "",
  body: "",
  status: 'public_state'
})
const errorMessages: string[] = reactive([])
const progress = ref(false)
const isAccordion = ref(false)

const createSentences = async (): Promise<void> => {
  try{
    errorMessages.splice(0)
    progress.value = true
    await axios.post("user/sentences", { sentence: sentence })
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

.accordion-title{
  cursor: pointer;
  user-select: none;
}

.accordion-title > span{
  transition: transform .3s;
  display:inline-block;
}
.accordion-title > span.open{
  transform: rotate(60deg);
}


</style>
