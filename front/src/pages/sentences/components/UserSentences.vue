<template>
  <v-card>
    <v-card-text>user sentences</v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import axios from "../../../plugins/axios"
import ErrorMessages from "../../../components/shared/ErrorMessages.vue"
import { useUserStore }  from "../../../store/userStore"
import { useFlashStore } from "../../../store/flashStore"
import { useTokenStore } from "../../../store/tokenStore"

const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()





</script>

<style scoped>
</style>
