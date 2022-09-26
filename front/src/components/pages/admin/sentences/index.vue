<template>
  <v-container>
    <p class="text-h4 ml-5">英文一覧</p>
    <v-form
      ref="form"
      lazy-validation
    >
      <div style="width: 500px" class="d-flex mt-3 ml-3">
        <v-text-field
          v-model="searchWord"
          label="検索"
          placeholder="検索ワードを入力"
          color="blue"
          density="comfortable"
          variant="outlined"
        ></v-text-field>
        <div class="select-container">
          <v-select
            v-model="itemValue"
            :items="items"
            class="ml-3"
            variant="outlined"
            density="comfortable"
          ></v-select>
        </div>
        <v-btn
          color="blue" 
          class="ml-3"
          @click="searchSentences(searchWord)"
        >
          <p class="text-white">検索</p>
        </v-btn>
      </div>
    </v-form>
    <v-divider></v-divider>
    <v-table class="admin-dashboard-table">
      <thead>
        <tr>
          <th class="text-lesft">
            ID
          </th>
          <th class="text-left">
            タイトル
          </th>
          <th class="text-left">
            ステータス
          </th>
          <th class="text-left">
            タイプ
          </th>
          <th class="text-left">
            作成日時
          </th>
          <th class="text-left">
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="item in sentences"
          :key="item.id"
        >
          <td>{{ item.id }}</td>
          <td>{{ item.title }}</td>
          <td>{{ item.status }}</td>
          <td>{{ item.createrType }}</td>
          <td>{{ item.createdAt }}</td>
          <td class="d-flex align-center">
            <!-- 詳細ボタン -->
            <v-btn  
              class="mr-3"
              color="info"
              @click="openSentenceDialog(item)"
            >
              詳細
            </v-btn>
            <!-- 編集ボタン -->
            <v-btn  
              class="mr-3" 
              color="success"
              @click="openEditSentenceDialog(item)"
            >
              編集
            </v-btn>
            <!-- 削除ボタン -->
            <v-btn 
              class=""
              color="error"
              @click="deleteSentence(item.id)"
            >
              削除
            </v-btn>
          </td>
        </tr>
      </tbody>
    </v-table>
    <v-pagination
      v-if="paginationLength > 1"
      v-model="page"
      class="mt-4 mb-2"
      :length="paginationLength"
      @update:model-value="paginate(page as number)"
    ></v-pagination>
  </v-container>
  <!-- 英文詳細モーダル -->
  <v-dialog v-model="sentenceDialog">
    <div class="page-profile py-5 pt-sm-10">
      <v-card width="600" class="mx-auto px-3 px-sm-5 py-3">
        <v-card-item>
          <v-card-title class="text-h6 text-center text-grey-darken-3 font-weight-bold tracking-widest">ユーザー詳細</v-card-title>
        </v-card-item>
        <v-card-text class="mt-3">
          <div class="text-center mt-3">
            <p class="text-subtitle-1 fs-small text-grey-darken-3">タイトル</p>
            <v-divider length="42" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
            <p class="mt-2 text-body-1 fs-large tracking-wide">{{ itemSentence?.title }}</p>
          </div>
          <div class="text-center mt-4">
            <p class="text-subtitle-1 fs-small text-grey-darken-3">本文</p>
            <v-divider length="110" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
            <p class="mt-2 text-body-1 tracking-wide">{{ itemSentence?.body }}</p>
          </div>
        </v-card-text>
      </v-card>
    </div>
  </v-dialog>

  <!-- 英文編集モーダル -->
  <v-dialog v-model="editSentenceDialog">
    <v-card width="600" class="mx-auto px-5 py-3">
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
            v-model="editedSentence.title"
            label="タイトル"
            placeholder="英文のタイトルを入力"
            color="blue"
            density="comfortable"
            variant="outlined"
            required
            :rules="titleRules"
          ></v-text-field>

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

          <v-btn 
            v-if="progress"
            width="100%"
            color="warning" 
            :disabled="true"
          >
            <v-progress-circular
              size="20"
              color="grey-darken-5"
              indeterminate
              width="3"
              class="progress2"
            ></v-progress-circular>
          </v-btn>
          <v-btn
            v-else
            :disabled="!valid"
            color="warning"
            class=""
            width="100%"
            @click="updateSentences(editedSentence)"
          >
             編集
          </v-btn>

        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import qs from "qs"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { useFlashStore } from "@/store/flashStore";
import ErrorMessages from "@/components/shared/ErrorMessages.vue"

interface Sentence {
  id: string
  title: string
  body: string
  status: string
  createrType: string
  createdAt: string
}
interface EditedSentence {
  id: string
  title: string
  body: string
  status: string
}

const router = useRouter()
const route = useRoute()
const flashStore = useFlashStore()
const errorMessages: string[] = reactive([])

const sentences = ref<Array<Sentence>>([])

const initialQueryOfPage = route.query.page? Number(route.query.page) : undefined
const initialQueryOfQ1 = route.query.q1? route.query.q1 as string : undefined
const initialQueryOfQ2 = route.query.q2? route.query.q2 as string : undefined
const page = ref(initialQueryOfPage)
const paginationLength = ref(1)
const searchWord = ref("")
const items = [
  { title: "指定なし", value: "" },
  { title: "公開", value: 0 },
  { title: "非公開", value: 1 },
]
const itemValue = ref("")
const itemSentence = ref<Sentence | null>(null)
const sentenceDialog = ref(false)
const editSentenceDialog = ref(false)
const editedSentence = reactive<EditedSentence>({
  id: "",
  title: "",
  body: "",
  status: ""
})
const form = ref<any>(null)


const fetchSentences = async (page?: string | number, q1?: string, q2?: string): Promise<void> => {
  try{
    const res = await axios.get("admin/sentences",{
      params: {
        page,
        q: {
          title_cont: q1,
          status_eq: q2
        }
      },
      paramsSerializer: params => {
        return qs.stringify(params)
      }
    })
    paginationLength.value= res.data.pagination.pages
    sentences.value = res.data.sentences
  } catch(e) {
    console.log(e)
  }
}
fetchSentences(initialQueryOfPage, initialQueryOfQ1, initialQueryOfQ2)

const paginate = (page: number) => {
  router.push({ 
    name: "AdminSentences", 
    query: { 
      page,
      q1: route.query.q1,
      q2: route.query.q2
    } 
  })
}

const searchSentences = (word: string) => {
  router.push({ 
    name: "AdminSentences", 
    query: {
      q1: word,
      q2: itemValue.value
    }
  })
}

onBeforeRouteUpdate(async (to) => {
  sentences.value = []
  await fetchSentences(to.query.page as string, to.query.q1 as string, to.query.q2 as string)
})

const openSentenceDialog = (sentence: Sentence): void => {
  itemSentence.value = sentence
  sentenceDialog.value = true
}

const openEditSentenceDialog = (sentence: Sentence): void => {
  editedSentence.id = sentence.id
  editedSentence.title = sentence.title
  editedSentence.body = sentence.body
  editedSentence.status = sentence.status
  editSentenceDialog.value = true
}


const valid = ref(true)
const titleRules = [
  (v: string) => !!v || 'タイトルを入力してください',
  (v: string) => (v && v.length <= 100) || '100文字以内で入力してください' 
]
const bodyRules = [
  (v: string) => !!v || '本文を入力してください',
  (v: string) => (v && v.length <= 10000) || '10000文字以内で入力してください' 
]
const progress = ref(false)


const updateSentences = async (sentence: EditedSentence): Promise<void> => {
  progress.value = true
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.patch(`admin/sentences/${sentence.id}`, { sentence })
    sentences.value = sentences.value.map((sentence: Sentence) => {
      if(sentence.id === res.data.sentence.id){
        return res.data.sentence
      }else{
        return sentence
      }
    })
    flashStore.succeedUpdateSentences()
    editSentenceDialog.value = false
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failUpdateSentences()
  }
  progress.value = false
}

const deleteSentence = async (id: string): Promise<void> => {
  if(confirm('削除してよろしいですか？')){
    try{
      await axios.delete(`admin/sentences/${id}`)
      sentences.value = sentences.value.filter((sentence: Sentence) => sentence.id != id)
      flashStore.succeedDeleteSentence()
    } catch(e) {
      console.log(e)
      flashStore.failDeleteSentence()
    }
  }
}

//プロフィールモーダルを出した時はvalidProfileがnullのため、validete()を実行しvalidProfileをtrueにさせる
watch(form, () => {
  if(form.value){
    form.value.validate()
  }
})
</script>

<style scoped>
.admin-dashboard-table tbody tr:nth-child(odd){
  background-color:#f0f0f0;
}

.select-container{
  width: 160px;
}

</style>