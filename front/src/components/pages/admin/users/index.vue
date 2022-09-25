<template>
  <v-container>
    <p class="text-h4 ml-5">ユーザー一覧</p>
    <v-form
      ref="form"
      lazy-validation
    >
    <div style="width: 400px" class="d-flex mt-3 ml-3">
      <v-text-field
        v-model="searchWord"
        label="検索"
        placeholder="検索ワードを入力"
        color="blue"
        density="comfortable"
        variant="outlined"
      ></v-text-field>
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
          <td>{{ item.role }}</td>
          <td>{{ item.createdAt }}</td>
          <td class="d-flex align-center">
            <!-- 詳細ボタン -->
            <v-btn  
              class="mr-3"
              color="info"
            >
              詳細
            </v-btn>
            <!-- 編集ボタン -->
            <v-btn  
              class="mr-3" 
              color="success"
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
</template>

<script setup lang="ts">
import { ref } from "vue"
import axios from "@/plugins/axios"
import qs from "qs"
import { useRouter, useRoute, onBeforeRouteUpdate } from "vue-router"
import { useFlashStore } from "@/store/flashStore";

interface User {
  id: number
  name: string
  email: string
  role: string
  createdAt: string
}

const router = useRouter()
const route = useRoute()
const flashStore = useFlashStore()

const users = ref<Array<User>>([])

const initialQueryOfPage = route.query.page? Number(route.query.page) : undefined
const initialQueryOfQ = route.query.q? route.query.q as string : undefined
const page = ref(initialQueryOfPage)
const paginationLength = ref(1)
const searchWord = ref("")


const fetchUsers = async (page?: string | number, word?: string): Promise<void> => {
  try{
    const res = await axios.get("admin/users",{
      params: {
        page,
        q: {
          name_cont: word
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
fetchUsers(initialQueryOfPage, initialQueryOfQ)

const paginate = (page: number) => {
  router.push({ 
    name: "AdminUsers", 
    query: { 
      page,
      q: route.query.q
    } 
  })
}

const searchUsers = (word: string) => {
  router.push({ 
    name: "AdminUsers", 
    query: {
      q: word
    }
  })
}

onBeforeRouteUpdate(async (to) => {
  users.value = []
  await fetchUsers(to.query.page as string, to.query.q as string)
})

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
</style>