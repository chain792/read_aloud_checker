<template>
  <v-btn 
    v-if="progress"
    :disabled="true"
    v-bind="$attrs"
  >
    <v-progress-circular
      size="20"
      color="grey-darken-5"
      indeterminate
      width="3"
    ></v-progress-circular>
  </v-btn>
  <v-btn
    v-else
    :disabled="disabled"
    v-bind="$attrs"
  >
    <slot />
  </v-btn>
</template>

<script setup lang="ts">
interface Props {
  progress: boolean
  disabled: boolean
}

defineProps<Props>()

</script>

<style scoped>
</style>
