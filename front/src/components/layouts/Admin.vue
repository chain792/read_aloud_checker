<template>
  <SideBar />
  <FlashMessage />
  <v-main>
    <router-view />
  </v-main>
</template>

<script setup lang="ts">
import SideBar from '@/components/shared/admin/SideBar.vue';
import FlashMessage from '@/components/shared/FlashMessage.vue'
</script>
