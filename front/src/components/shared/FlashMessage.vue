<template>
  <v-snackbar
    v-model="flashStore.status"
    location="top right"
    class="mt-14"
    :color="flashStore.color"
  >
    <p class="text-white font-weight-bold text-body-1">{{ flashStore.message }}</p>
  </v-snackbar>
</template>

<script setup lang="ts">
import { useFlashStore } from "@/store/flashStore"

const flashStore = useFlashStore()
</script>

<style>
.v-snackbar__wrapper{
  min-width: 300px !important;
}
</style>
