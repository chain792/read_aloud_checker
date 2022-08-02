<template>
  <v-card>
    <v-tabs
      v-model="tab"
      centered
      grow
      stacked
    >
      <v-tab value="tab-1">
        <v-icon>mdi-newspaper</v-icon>
        おすすめの英文
      </v-tab>

      <v-tab value="tab-2">
        <v-icon>mdi-account-multiple</v-icon>
        みんなが投稿した英文
      </v-tab>
    </v-tabs>

    <v-window v-model="tab">
      <v-window-item value="tab-1">
        <NewsSentences />
      </v-window-item>
      <v-window-item value="tab-2">
        <UserSentences />
      </v-window-item>
    </v-window>
  </v-card>
</template>

<script setup lang="ts">
import { ref } from "vue"
import NewsSentences from "./components/NewsSentences.vue"
import UserSentences from "./components/UserSentences.vue"


const tab = ref(null)

</script>

<style scoped>
</style>
