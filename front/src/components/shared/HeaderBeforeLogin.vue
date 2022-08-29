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

    <v-btn
      density="compact"
      size="x-large"
      variant="text"
      class="mr-2 font-weight-bold"
      rounded="xl"
      :to="{ name: 'Login' }"
    >
      ログイン
    </v-btn>


    <v-btn
      density="comfortable"
      color="white"
      size="x-large"
      variant="text"
      class="mr-2 font-weight-bold"
      rounded="xl"
      :to="{ name: 'Signup' }"
    >
      新規登録
    </v-btn>


    
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
.v-app-bar a{
  text-decoration: none;
}

.logo{
  position: absolute;
  top: 1px;
  left: 10px;
  width: 170px !important;
  height: 62px !important;
}
</style>
