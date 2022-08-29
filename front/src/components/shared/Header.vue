<template>
  <v-app-bar
    :color="headerColor"
    :elevation="headerElevation"
  >
    <router-link :to="{ name: 'TopPage' }">
      <img src="/logo.png" class="logo" alt="">
    </router-link>

    <v-spacer></v-spacer>

    <router-link :to="{ name: 'Sentences' }" class="mr-5 font-weight-bold">
      英文一覧
    </router-link>

    <router-link :to="{ name: 'NewSentence' }" class="mr-5 font-weight-bold">
      英文投稿
    </router-link>

    <router-link :to="{ name: 'BookmarkSentences' }" class="mr-5 font-weight-bold">
      ブックマーク
    </router-link>

    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn
          color="rgba(0,200,255,1)"
          v-bind="props"
        >
          <img :src="imageUrl('avatar', userStore.authUser!)" alt="">
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

  <!-- 設定画面モーダル -->
  <teleport to="body">
    <div v-show="settingsDialog" class="modal" @click="settingsDialog = false" ></div>
    <div v-show="settingsDialog" class="modal-content">
      <v-card width="500" class="mx-auto px-5 py-3">
        <v-card-item>
          <div class="d-flex">
            <v-card-title class="text-h6 ml-auto">音声の性別を変更する</v-card-title>
            <v-btn
              icon
              elevation="0"
              class="ml-auto"
              @click="settingsDialog = false"
            >
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </div>
        </v-card-item>
        <v-card-text class="mt-3">
          <div class="d-flex justify-space-around mt-6">
            <v-btn color="success" @click="changeListeningSexToMale">男性ボイス</v-btn>
            <v-btn color="success" @click="changeListeningSexToFemale">女性ボイス</v-btn>
          </div>
        </v-card-text>
      </v-card>
    </div>
  </teleport>
</template>

<script setup lang="ts">
import { ref, computed, ComputedRef } from "vue"
import axios from "@/plugins/axios"
import { useUserStore }  from "@/store/userStore"
import { useFlashStore } from "@/store/flashStore"
import { useTokenStore } from "@/store/tokenStore"
import { useHeaderStore } from "@/store/headerStore"
import { useRouter } from 'vue-router'
import { imageUrl } from "@/common/imageUrl"

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()
const headerStore = useHeaderStore()
const router = useRouter()

const headerColor: ComputedRef<string> = computed(() => {
  if(headerStore.isOpacity){
    return 'rgba(255,255,255,0)'
  }else{
    return 'rgba(255,255,255,1)'
  }
})

const headerElevation: ComputedRef<string> = computed(() => {
  if(headerStore.isOpacity){
    return '0'
  }else{
    return '1'
  }
})

const items = [
  { title: "マイページ", click: linkToMypage },
  { title: "プロフィール", click: linkToProfile },
  { title: "音声設定", click: openSettingsModal },
  { title: "ログアウト", click: logout },
]

const settingsDialog = ref(false)

async function logout(): Promise<void>{
  flashStore.$reset()
  try{
    await axios.delete("logout")
    userStore.$reset()
    tokenStore.$reset()
    flashStore.succeedLogout()
    router.push({ name: "TopPage" })
  } catch(e) {
    console.log(e)
    flashStore.failLogout()
  }
}

function linkToProfile(): void{
  router.push({ name: "Profile" })
}

function linkToMypage(): void{
  router.push({ name: "Mypage" })
}

function openSettingsModal(): void{
  settingsDialog.value = true
}

async function changeListeningSexToMale(): Promise<void>{
  flashStore.$reset()
  try{
    await axios.patch("user/listening_sex", {
      user: {
        listening_sex: "male"
      }
    })
    userStore.changeListeningSexToMale()
    settingsDialog.value = false
    flashStore.chengedListeningSexToMale()
  } catch(e) {
    console.log(e)
  }
}

async function changeListeningSexToFemale(): Promise<void>{
  flashStore.$reset()
  try{
    await axios.patch("user/listening_sex", {
      user: {
        listening_sex: "female"
      }
    })
    userStore.changeListeningSexToFemale()
    settingsDialog.value = false
    flashStore.chengedListeningSexToFemale()
  } catch(e) {
    console.log(e)
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

.modal{
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: rgba(0,0,0,.3);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.modal-content{
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.logo{
  position: absolute;
  top: 1px;
  left: 10px;
  width: 170px !important;
  height: 62px !important;
}
</style>
