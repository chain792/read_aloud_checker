<template>
  <div>トップページです</div>
  <div>{{ store.hello }}</div>
  <v-btn
    flat
    color="secondary"
  >
    Secondary
  </v-btn>
</template>

<script setup lang="ts">
import { useStore } from '../../store/store';
const store = useStore()
</script>

<style scoped>
</style>
