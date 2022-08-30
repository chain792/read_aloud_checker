<template>
  <v-app-bar
    :color="headerColor"
    :elevation="headerElevation"
  >
    <router-link :to="{ name: 'TopPage' }">
      <img src="/logo.png" class="logo" alt="">
    </router-link>

    <v-spacer></v-spacer>

    <router-link v-show="!spScreen" :to="{ name: 'Sentences' }" class="mr-5 header-text text-grey-darken-4">
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
  </teleport>
</template>

<script setup lang="ts">
import { ref, computed, ComputedRef } from "vue"
import { useHeaderStore } from "@/store/headerStore"
import { useRouter } from 'vue-router'
import { useDisplay } from "vuetify"

const headerStore = useHeaderStore()
const router = useRouter()
const display = useDisplay()

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

const spScreen: ComputedRef<boolean> = computed(() => {
  if (display.xs.value) {
    return true
  } else {
    return false
  }
})

const sideItems = [
  { title: "トップページ", click: linkToTopPage },
  { title: "英文一覧", click: linkToSentences },
  { title: "ログイン", click: linkToLogin },
  { title: "新規登録", click: linkToSignup },
]

const drawer = ref(false)

function linkToTopPage(): void{
  drawer.value = false
  router.push({ name: "TopPage" })
}

function linkToSentences(): void{
  drawer.value = false
  router.push({ name: "Sentences" })
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
</style>
