<template>
  <v-app>
    <Header v-if="false" />
    <HeaderBeforeLoginVue v-else />
    <v-main>
      <router-view />
    </v-main>
    <Footer />
  </v-app>
</template>

<script setup lang="ts">
import Header from './components/Header.vue'
import HeaderBeforeLoginVue from './components/HeaderBeforeLogin.vue'
import Footer from './components/Footer.vue'
</script>
