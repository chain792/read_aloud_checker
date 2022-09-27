<template>
  <v-container>
    <p class="text-h4 ml-5">ユーザー一覧</p>
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
          @click="searchUsers(searchWord)"
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
            名前
          </th>
          <th class="text-left">
            メールアドレス
          </th>
          <th class="text-left">
            権限
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
          v-for="item in users"
          :key="item.id"
        >
          <td>{{ item.id }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.email }}</td>
          <td>{{ role_i18n(item.role) }}</td>
          <td>{{ item.createdAt }}</td>
          <td class="d-flex align-center">
            <!-- 詳細ボタン -->
            <v-btn  
              class="mr-3"
              color="info"
              @click="openUserDialog(item)"
            >
              詳細
            </v-btn>
            <!-- 編集ボタン -->
            <v-btn  
              class="mr-3" 
              color="success"
              @click="openEditUserDialog(item)"
            >
              編集
            </v-btn>
            <!-- 削除ボタン -->
            <v-btn 
              class=""
              color="error"
              @click="deleteUser(item.id)"
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
  <!-- ユーザー詳細モーダル -->
  <v-dialog v-model="userDialog">
    <div class="page-profile py-5 pt-sm-10">
      <v-card width="600" class="mx-auto px-3 px-sm-5 py-3">
        <v-card-item>
          <v-card-title class="text-h6 text-center text-grey-darken-3 font-weight-bold tracking-widest">ユーザー詳細</v-card-title>
        </v-card-item>
        <v-card-text class="mt-3">
          <div class="text-center">
            <img :src="avatarUrl(itemUser!)" alt="アバター" class="avatar">
          </div>
          <div class="text-center mt-3">
            <p class="text-subtitle-1 fs-small text-grey-darken-3">名前</p>
            <v-divider length="42" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
            <p class="mt-2 text-body-1 fs-large tracking-wide">{{ itemUser?.name }}</p>
          </div>
          <div class="text-center mt-4">
            <p class="text-subtitle-1 fs-small text-grey-darken-3">メールアドレス</p>
            <v-divider length="110" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
            <p class="mt-2 text-body-1 tracking-wide">{{ itemUser?.email }}</p>
          </div>
        </v-card-text>
      </v-card>
    </div>
  </v-dialog>


  <!-- ユーザー編集モーダル -->
  <v-dialog v-model="editUserDialog">
    <v-card width="600" class="mt-n10 px-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">プロフィール編集</v-card-title>
        <v-card-subtitle v-if="errorMessages.length" class="mt-3">
          <ErrorMessages :error-messages="errorMessages" />
        </v-card-subtitle>
      </v-card-item>
      <v-card-text class="mt-3">
        <v-form
          v-model="validProfile"
        >
          <div class="mt-5">
            <v-text-field
              v-model="editedUser!.name"
              label="名前"
              placeholder="名前を入力"
              color="blue"
              density="comfortable"
              variant="outlined"
              required
              :rules="nameRules"
            ></v-text-field>
          </div>
          <div class="d-sm-flex justify-space-around">
            <v-btn 
              color="accent" 
              @click="editUserDialog = false"
            >
              キャンセル
            </v-btn>
            <ProgressButton
              color="warning"
              :progress="progress"
              :disabled="!validProfile"
              class="ml-sm-3 mt-3 mt-sm-0"
              @click="updateProfile(editedUser)"
            >
              この内容で編集する
            </ProgressButton>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "@/plugins/axios"
import Axios from "axios"
import qs from "qs"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { useFlashStore } from "@/store/flashStore";
import { role_i18n } from "@/common/enum"
import { avatarUrl } from "@/common/imageUrl"
import ErrorMessages from "@/components/shared/ErrorMessages.vue"
import ProgressButton from "@/components/shared/ProgressButton.vue"

interface User {
  id: number
  name: string
  email: string
  role: string
  createdAt: string
}
interface EditedUser {
  id: number
  name: string
}

const router = useRouter()
const route = useRoute()
const flashStore = useFlashStore()
const errorMessages: string[] = reactive([])

const users = ref<Array<User>>([])

const initialQueryOfPage = route.query.page? Number(route.query.page) : undefined
const initialQueryOfQ1 = route.query.q1? route.query.q1 as string : undefined
const initialQueryOfQ2 = route.query.q2? route.query.q2 as string : undefined
const page = ref(initialQueryOfPage)
const paginationLength = ref(1)
const searchWord = ref("")
const items = [
  { title: "指定なし", value: "" },
  { title: "一般", value: 0 },
  { title: "管理者", value: 1 },
]
const itemValue = ref("")
const itemUser = ref<User | null>(null)
const userDialog = ref(false)
const editUserDialog = ref(false)
const editedUser = reactive<EditedUser>({
  id: 0,
  name: ""
})


const fetchUsers = async (page?: string | number, q1?: string, q2?: string): Promise<void> => {
  try{
    const res = await axios.get("admin/users",{
      params: {
        page,
        q: {
          name_cont: q1,
          role_eq: q2
        }
      },
      paramsSerializer: params => {
        return qs.stringify(params)
      }
    })
    paginationLength.value= res.data.pagination.pages
    users.value = res.data.users
  } catch(e) {
    console.log(e)
  }
}
fetchUsers(initialQueryOfPage, initialQueryOfQ1, initialQueryOfQ2)

const paginate = (page: number) => {
  router.push({ 
    name: "AdminUsers", 
    query: { 
      page,
      q1: route.query.q1,
      q2: route.query.q2
    } 
  })
}

const searchUsers = (word: string) => {
  router.push({ 
    name: "AdminUsers", 
    query: {
      q1: word,
      q2: itemValue.value
    }
  })
}

onBeforeRouteUpdate(async (to) => {
  users.value = []
  await fetchUsers(to.query.page as string, to.query.q1 as string, to.query.q2 as string)
})

const openUserDialog = (user: User): void => {
  itemUser.value = user
  userDialog.value = true
}

const openEditUserDialog = (user: User): void => {
  editedUser.id = user.id
  editedUser.name = user.name
  editUserDialog.value = true
}


const validProfile = ref(true)
const nameRules = [
  (v: string) => !!v || '名前を入力してください',
  (v: string) => (v && v.length <= 50) || '50文字以内で入力してください' 
]
const progress = ref(false)


const updateProfile = async (user: EditedUser): Promise<void> => {
  progress.value = true
  flashStore.$reset()
  try{
    errorMessages.splice(0)
    const res = await axios.patch(`admin/users/${user.id}`, { user })
    users.value = users.value.map((user: User) => {
      if(user.id === res.data.user.id){
        return res.data.user
      }else{
        return user
      }
    })
    flashStore.succeedEditUser()
    editUserDialog.value = false
  } catch(e) {
    if(Axios.isAxiosError(e) && e.response && e.response.data && Array.isArray(e.response.data)){
      e.response.data.forEach(v => {
        errorMessages.push(v)
      })
    }else{
      console.log(e)
    }
    flashStore.failEditUser()
  }
  progress.value = false
}

const deleteUser = async (id: number): Promise<void> => {
  if(confirm('削除してよろしいですか？')){
    try{
      await axios.delete(`admin/users/${id}`)
      users.value = users.value.filter((user: User) => user.id != id)
      flashStore.succeedDeleteUser()
    } catch(e) {
      console.log(e)
      flashStore.failDeleteUser()
    }
  }
}
</script>

<style scoped>
.admin-dashboard-table tbody tr:nth-child(odd){
  background-color:#f0f0f0;
}

.select-container{
  width: 160px;
}

.avatar{
  border-radius: 50%;
  width: 60px;
  height: 60px;
}
</style>