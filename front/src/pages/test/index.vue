<template>
  <div>TEST</div>
<Test>
  <template v-slot:unko="aiu">
  aaaaaaaaas{{aiu.mmm}}
  </template>
</Test>
<div>------------</div>
<Test v-slot="slotProps">
  {{ slotProps.mmm }}
</Test>
</template>

<script setup lang="ts">
import Test from "../../components/Test.vue"
</script>

<style scoped></style>
