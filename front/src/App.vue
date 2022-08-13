<template>
  <v-app>
    <Header v-if="userStore.authUser" />
    <HeaderBeforeLoginVue v-else />
    <FlashMessage />
    <v-main>
      <router-view />
    </v-main>
    <Footer />
  </v-app>
</template>

<script setup lang="ts">
import Header from './components/shared/Header.vue'
import HeaderBeforeLoginVue from './components/shared/HeaderBeforeLogin.vue'
import Footer from './components/shared/Footer.vue'
import FlashMessage from './components/shared/FlashMessage.vue'
import { useUserStore } from './store/userStore'

const userStore = useUserStore()

</script>

<style>
body {
  font-family: 'Meiryo';
}
</style>
