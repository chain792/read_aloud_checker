<template>
  <v-container>
    <v-card>
      <v-tabs
        v-model="tab"
        centered
        grow
        stacked
      >
        <v-tab value="tab-1">
          音読記録
        </v-tab>

        <v-tab value="tab-2">
          音読履歴
        </v-tab>
      </v-tabs>

      <v-window v-model="tab">
        <v-window-item value="tab-1">
          <Record />
        </v-window-item>
        <v-window-item value="tab-2">
          222
        </v-window-item>
      </v-window>
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from "vue"
import Record from "./components/Record.vue"

const tab = ref(null)

</script>

<style scoped>
</style>
