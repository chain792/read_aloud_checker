<template>
  <div>トップページです</div>
  <div>{{ store.hello }}</div>
</template>

<script setup lang="ts">
import { useStore } from '../../store/store';
const store = useStore()
</script>

<style scoped>
</style>
