<template>
  <v-container>
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

const queryValueOfPage = route.query.page? Number(route.query.page) : undefined
const page = ref(queryValueOfPage)
const paginationLength = ref(1)


const fetchUsers = async (page?: string | number): Promise<void> => {
  try{
    const query =  page ? `?page=${page}` : ''
    const res = await axios.get("admin/users" + query)
    paginationLength.value= res.data.pagination.pages
    users.value = res.data.users
  } catch(e) {
    console.log(e)
  }
}
fetchUsers(queryValueOfPage)

const paginate = (page: number) => {
  router.push({ name: "AdminUsers", query: { page } })
}

onBeforeRouteUpdate(async (to) => {
  users.value = []
  await fetchUsers(to.query.page as string)
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