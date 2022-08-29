<template>
  <v-app-bar
    :color="headerColor"
    :elevation="headerElevation"
  >
    <router-link :to="{ name: 'TopPage' }">
      <img src="/logo.png" class="logo" alt="">
    </router-link>

    <v-spacer></v-spacer>

    <router-link :to="{ name: 'Sentences' }" class="mr-5 header-text text-grey-darken-4">
      英文一覧
    </router-link>

    <router-link
      class="mr-5 header-text text-grey-darken-4"
      :to="{ name: 'Login' }"
    >
      ログイン
    </router-link>

    <router-link
      class="mr-3 header-text text-grey-darken-4"
      :to="{ name: 'Signup' }"
    >
      新規登録
    </router-link>


    
  </v-app-bar>
</template>

<script setup lang="ts">
import { computed, ComputedRef } from "vue"
import { useHeaderStore } from "@/store/headerStore"

const headerStore = useHeaderStore()

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
