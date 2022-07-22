<template>
  <v-app-bar
    color="rgba(0,200,255,1)"
  >
    <router-link :to="{ name: 'TopIndex' }">
      <v-app-bar-title class="text-white font-weight-bold">音読スター</v-app-bar-title>
    </router-link>

    <v-spacer></v-spacer>

    <router-link to="#" class="mr-5 text-white font-weight-bold">
      英文一覧
    </router-link>

    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn
          color="rgba(0,200,255,1)"
          v-bind="props"
        >
          <img src="/public/cat.jpeg" alt="">
        </v-btn>
      </template>
      <v-list>
        <v-list-item
          v-for="(item, index) in items"
          :key="index"
          :value="index"
        >
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    
  </v-app-bar>
</template>

<script setup lang="ts">
const items = [
  { title: "マイページ" },
  { title: "プロフィール" },
  { title: "ログアウト" },
]
</script>

<style scoped>
.v-app-bar img{
  border-radius: 50%;
  width: 40px;
  height: 40px;
}

.v-app-bar a{
  text-decoration: none;
}

.v-btn__overlay {
  opacity: 0  !important;
}
</style>
