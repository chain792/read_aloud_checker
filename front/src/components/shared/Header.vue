<template>
  <v-app-bar
    :color="headerColor"
    :elevation="headerElevation"
  >
    <router-link :to="{ name: 'TopPage' }">
      <img src="/logo.png" class="logo" alt="">
    </router-link>

    <v-spacer></v-spacer>

    <router-link v-show="!spScreen" :to="{ name: 'NewsSentences' }" class="mr-5 header-text text-grey-darken-4">
      英文一覧
    </router-link>

    <router-link v-show="!spScreen" :to="{ name: 'BookmarkSentences' }" class="header-text header-text-bookmark text-grey-darken-4">
      ブックマーク
    </router-link>

    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn
          v-show="!spScreen"
          color="rgba(255,255,255,1)"
          v-bind="props"
        >
          <img :src="avatarUrl(userStore.authUser!)" alt="" class="avatar">
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

    <v-app-bar-nav-icon v-show="spScreen" class="sp-menu" @click="drawer = !drawer"></v-app-bar-nav-icon>
  </v-app-bar>

  <!-- サイドメニュー -->
  <teleport to="body">
    <div v-show="drawer" class="modal" @click="drawer = false" ></div>
    <transition name="side-menu-animation">
      <div v-show="drawer" class="side-menu">
        <v-list>
          <v-list-item
            v-for="(item, index) in sideItems"
            :key="index"
            :value="index"
            @click="item.click"
          >
            <v-list-item-title class="text-body-1">{{ item.title }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </div>
    </transition>
  </teleport>

  <!-- 設定画面モーダル -->
  <teleport to="body">
    <div v-show="settingsDialog" class="modal" @click="settingsDialog = false" ></div>
    <div v-show="settingsDialog" class="modal-content">
      <v-card :width="modalWidth500" class="mx-assto px-5 py-3">
        <v-card-item>
          <div class="d-flex">
            <v-card-title class="text-h6 ml-auto">お手本の音声の性別を変更する</v-card-title>
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
            <v-btn color="blue-accent-4"  variant="tonal" @click="changeListeningSexToMale">男性ボイス</v-btn>
            <v-btn color="pink-accent-4" variant="tonal" @click="changeListeningSexToFemale">女性ボイス</v-btn>
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
import { avatarUrl } from "@/common/imageUrl"
import { modalWidth500, spScreen } from "@/common/width"

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
  { title: "作成した英文", click: linkToMySentences },
  { title: "音声設定", click: openSettingsModal },
  { title: "ログアウト", click: logout },
]

const sideItems = [
  { title: "トップページ", click: linkToTopPage },
  { title: "英文一覧", click: linkToSentences },
  { title: "ブックマーク", click: linkToBookmarkSentences },
  { title: "マイページ", click: linkToMypage },
  { title: "プロフィール", click: linkToProfile },
  { title: "作成した英文", click: linkToMySentences },
  { title: "音声設定", click: openSettingsModal },
  { title: "利用規約", click: linkToTerms },
  { title: "プライバシーポリシー", click: linkToPrivacy },
  { title: "お問い合わせ", click: linkToContact },
  { title: "ログアウト", click: logout },
]

const settingsDialog = ref(false)
const drawer = ref(false)

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

function linkToTopPage(): void{
  drawer.value = false
  router.push({ name: "TopPage" })
}

function linkToProfile(): void{
  drawer.value = false
  router.push({ name: "Profile" })
}

function linkToMypage(): void{
  drawer.value = false
  router.push({ name: "MyRecord" })
}

function linkToSentences(): void{
  drawer.value = false
  router.push({ name: "NewsSentences" })
}

function linkToMySentences(): void{
  drawer.value = false
  router.push({ name: "MySentences" })
}

function linkToBookmarkSentences(): void{
  drawer.value = false
  router.push({ name: "BookmarkSentences" })
}

function linkToTerms(): void{
  drawer.value = false
  router.push({ name: "Terms" })
}

function linkToPrivacy(): void{
  drawer.value = false
  router.push({ name: "Privacy" })
}

function linkToContact(): void{
  drawer.value = false
  window.open("https://docs.google.com/forms/d/e/1FAIpQLSfFvUX5OG5vdFZYL2qqrn5PTVzzi8FGost6k1xucXdta1qI2Q/viewform?usp=sf_link")
}

function openSettingsModal(): void{
  drawer.value = false
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
.avatar{
  border-radius: 50%;
  width: 40px;
  height: 40px;
}

.v-btn__overlay {
  opacity: 0  !important;
}

.logo{
  position: absolute;
  top: 1px;
  left: 10px;
  width: 170px !important;
  height: 62px !important;
}

.header-text{
  font-weight: 500;
  font-size: 18px;
  text-decoration: none;
  width: 75px;
}

.header-text:hover{
  color: #ef8060 !important;
  font-weight: 600;
}

.header-text-bookmark{
  width: 110px;
}
</style>
