<template>
  <v-app-bar
    color="rgba(0,200,255,1)"
  >
    <router-link :to="{ name: 'TopIndex' }">
      <v-app-bar-title class="text-white font-weight-bold">音読スター</v-app-bar-title>
    </router-link>

    <v-spacer></v-spacer>

    <router-link to="#" class="mr-5 text-white font-weight-bold">
      ログイン
    </router-link>

    <router-link to="#" class="mr-5 text-white font-weight-bold">
      新規登録
    </router-link>


    
  </v-app-bar>
</template>

<script setup lang="ts">
</script>

<style>
.v-app-bar a{
  text-decoration: none;
}
</style>
