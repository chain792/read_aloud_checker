<template>
  <SideBar />
  <v-main>
    <router-view />
  </v-main>
</template>

<script setup lang="ts">
import SideBar from '../shared/admin/SideBar.vue';

</script>
