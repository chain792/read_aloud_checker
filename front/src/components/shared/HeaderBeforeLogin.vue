<template>
  <v-app-bar
    color="rgba(0,200,255,1)"
  >
    <router-link :to="{ name: 'TopIndex' }">
      <v-app-bar-title class="text-white font-weight-bold">音読スター</v-app-bar-title>
    </router-link>

    <v-spacer></v-spacer>

    <v-btn
      density="compact"
      color="white"
      size="x-large"
      variant="text"
      class="mr-2 font-weight-bold"
      rounded="xl"
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
      :to="{ name: 'SignupIndex' }"
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
