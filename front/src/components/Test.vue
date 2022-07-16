<template>
  <button><slot name="unko" :mmm="data">submit</slot></button>
</template>

<script setup lang="ts">
import { ref } from "vue"
const data = ref("hello")
</script>

<style scoped></style>