<template>
  <v-app-bar
    color="rgba(0,200,255,1)"
  >
    <router-link :to="{ name: 'TopIndex' }">
      <v-app-bar-title class="text-white font-weight-bold">音読スター</v-app-bar-title>
    </router-link>

    <v-spacer></v-spacer>

    <router-link :to="{ name: 'SentencesIndex' }" class="mr-5 text-white font-weight-bold">
      英文一覧
    </router-link>

    <router-link :to="{ name: 'NewSentences' }" class="mr-5 text-white font-weight-bold">
      英文投稿
    </router-link>

    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn
          color="rgba(0,200,255,1)"
          v-bind="props"
        >
          <img src="/public/cat.jpeg" alt="">
        </v-btn>
      </template>
      <v-list>
        <v-list-item
          v-for="(item, index) in items"
          :key="index"
          :value="index"
          @click="item.click"
        >
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

  </v-app-bar>
</template>

<script setup lang="ts">
import axios from "../../plugins/axios"
import { useUserStore }  from "../../store/userStore"
import { useFlashStore } from "../../store/flashStore"
import { useTokenStore } from "../../store/tokenStore"
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()
const router = useRouter()

const items = [
  { title: "マイページ", click: logout },
  { title: "プロフィール", click: logout },
  { title: "ログアウト", click: logout },
]

async function logout(): Promise<void>{
  try{
    const res = await axios.delete("logout")
    console.log(res)
    userStore.$reset()
    tokenStore.$reset()
    flashStore.succeedLogout()
    router.push({ name: "TopIndex" })
  } catch(e) {
    console.log(e)
    flashStore.failLogout()
  }
}

</script>

<style scoped>
.v-app-bar img{
  border-radius: 50%;
  width: 40px;
  height: 40px;
}

.v-app-bar a{
  text-decoration: none;
}

.v-btn__overlay {
  opacity: 0  !important;
}
</style>
