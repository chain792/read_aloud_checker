<template>
  <Header v-if="userStore.authUser" />
  <HeaderBeforeLoginVue v-else />
  <FlashMessage />
  <v-main>
    <router-view />
  </v-main>
  <Footer v-show="!spScreen" />
</template>

<script setup lang="ts">
import { computed, ComputedRef } from "vue"
import Header from '@/components/shared/Header.vue'
import HeaderBeforeLoginVue from '@/components/shared/HeaderBeforeLogin.vue'
import Footer from '@/components/shared/Footer.vue'
import FlashMessage from '@/components/shared/FlashMessage.vue'
import { useUserStore } from '@/store/userStore'
import { useDisplay } from "vuetify"

const display = useDisplay()
const userStore = useUserStore()

const spScreen: ComputedRef<boolean> = computed(() => {
  if (display.xs.value) {
    return true
  } else {
    return false
  }
})

</script>