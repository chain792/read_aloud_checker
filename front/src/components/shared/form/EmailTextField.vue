<template>
  <v-text-field
    type="email"
    color="blue"
    density="comfortable"
    variant="outlined"
    required
    :rules="emailRules"
    v-bind="$attrs"
  ></v-text-field>
</template>

<script setup lang="ts">
import { emailRules } from '@/common/rules';

</script>

<style scoped>
</style>