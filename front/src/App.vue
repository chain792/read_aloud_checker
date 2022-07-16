<template>
  <v-app>
    <Header v-if="false" />
    <HeaderBeforeLoginVue v-else />
    <v-main>
      <router-view />
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
import Header from './components/Header.vue'
import HeaderBeforeLoginVue from './components/HeaderBeforeLogin.vue'
</script>
