<template>
  <v-text-field
    :type="isVisiblePassword ? 'text' : 'password'"
    color="blue"
    density="comfortable"
    variant="outlined"
    required
    :rules="passwordRules"
    :append-inner-icon="isVisiblePassword ? 'mdi-eye' : 'mdi-eye-off'"
    v-bind="$attrs"
    @click:append-inner="isVisiblePassword = !isVisiblePassword"
  ></v-text-field>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { passwordRules } from '@/common/rules';

const isVisiblePassword = ref(false)
</script>

<style scoped>
</style>