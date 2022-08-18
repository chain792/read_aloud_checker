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
          <Histories />
        </v-window-item>
      </v-window>
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { ref, watch } from "vue"
import Record from "./components/Record.vue"
import Histories from "./components/Histories.vue"

const initilaTabValue: string = sessionStorage.mypageTab ? sessionStorage.mypageTab : "tab-1"
const tab = ref(initilaTabValue)

watch(tab, () => {
  if(!tab.value) return
  sessionStorage.mypageTab = tab.value
})

</script>

<style scoped>
</style>
