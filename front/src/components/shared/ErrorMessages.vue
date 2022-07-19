<template>
  <v-alert
    v-for="(message, index) in props.errorMessages"
    :key="index"
    class="mt-3"
    type="error"
    density="compact"
    variant="tonal"
    icon="mdi-alert-circle"
  >
    <p class="text-wrap" style="font-size: 0.85rem;">{{ message }}</p>
  </v-alert>
</template>

<script setup lang="ts">
interface Props {
  errorMessages: string[]
}
const props = defineProps<Props>();
</script>

<style scoped>
</style>
