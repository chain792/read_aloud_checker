<template>
  <v-navigation-drawer color="blue-grey-darken-4">
    <v-sheet
      color="blue-grey-darken-4"
      class="pa-4"
    >
      <div class="text-center pa-3 side-bar-title">音読スター</div>
    </v-sheet>
    <v-divider color="white"></v-divider>
    <v-list class="bg-blue-grey-darken-4">
      <v-list-item
        v-for="[icon, text] in links"
        :key="icon"
        link
      >
        <v-icon>{{ icon }}</v-icon>
        <v-list-item-content>
          <v-list-item-title>{{ text }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>

</template>

<script setup lang="ts">

const links = [
      ['mdi-inbox-arrow-down', 'Inbox'],
      ['mdi-send', 'Send'],
      ['mdi-delete', 'Trash'],
      ['mdi-alert-octagon', 'Spam'],
]

</script>

<style scoped>
.side-bar-title{
  font-size: 28px;
  letter-spacing: 1px;
}
</style>