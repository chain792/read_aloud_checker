<template>
  <v-app-bar
    color="rgba(0,200,255,1)"
  >
    <router-link :to="{ name: 'TopPage' }">
      <v-app-bar-title class="text-white font-weight-bold">音読スター</v-app-bar-title>
    </router-link>

    <v-spacer></v-spacer>

    <router-link :to="{ name: 'Sentences' }" class="mr-5 text-white font-weight-bold">
      英文一覧
    </router-link>

    <v-btn
      density="compact"
      color="white"
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
</script>

<style scoped>
.v-app-bar a{
  text-decoration: none;
}
</style>
