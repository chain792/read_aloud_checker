<template>
  <v-app-bar
    :color="headerColor"
    :elevation="headerElevation"
  >
    <router-link :to="{ name: 'TopPage' }">
      <img src="/logo.png" class="logo" alt="">
    </router-link>

    <v-spacer></v-spacer>

    <div 
      v-show="pcScreen"
      @keydown.enter="searchSentence"
    >
      <BaseTextField
        v-model="searchWord"
        placeholder="英文を検索"
        class="search-field mr-5"
        required
        :hide-details="true"
        append-inner-icon="mdi-magnify"
        density="compact"
        @click:append-inner="searchSentence"
      ></BaseTextField>
    </div>

    <router-link v-show="!spScreen" :to="{ name: 'NewsSentences' }" class="mr-5 header-text text-grey-darken-4">
      英文一覧
    </router-link>

    <router-link
      v-show="!spScreen"
      class="mr-5 header-text text-grey-darken-4"
      :to="{ name: 'Login' }"
    >
      ログイン
    </router-link>

    <router-link
      v-show="!spScreen"
      class="mr-3 header-text text-grey-darken-4"
      :to="{ name: 'Signup' }"
    >
      新規登録
    </router-link>

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
</template>

<script setup lang="ts">
import { ref, computed, ComputedRef } from "vue"
import { useHeaderStore } from "@/store/headerStore"
import { useRouter } from 'vue-router'
import { spScreen, pcScreen } from "@/common/width"
import BaseTextField from "@/components/shared/form/BaseTextField.vue"

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

const sideItems = [
  { title: "トップページ", click: linkToTopPage },
  { title: "英文一覧", click: linkToSentences },
  { title: "ログイン", click: linkToLogin },
  { title: "新規登録", click: linkToSignup },
]

const drawer = ref(false)
const searchWord = ref("")

const searchSentence = (): void => {
  router.push({ name: "SearchSentences", query: { keyword: searchWord.value } })
}

function linkToTopPage(): void{
  drawer.value = false
  router.push({ name: "TopPage" })
}

function linkToSentences(): void{
  drawer.value = false
  router.push({ name: "NewsSentences" })
}

function linkToLogin(): void{
  drawer.value = false
  router.push({ name: "Login" })
}

function linkToSignup(): void{
  drawer.value = false
  router.push({ name: "Signup" })
}


</script>

<style scoped>
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

.search-field{
  width: 300px;
}
</style>
