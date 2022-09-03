<template>
  <div class="page-user py-5 pt-sm-10">
    <v-card :width="cardWidth" class="mx-auto px-3 px-sm-5 py-3">
      <v-card-item>
        <v-card-title class="text-center text-h5">ユーザー詳細</v-card-title>
      </v-card-item>
      <v-card-text v-if="user" class="mt-3">
        <div class="text-center">
          <img :src="imageUrl('avatar', user)" alt="アバター" class="avatar">
        </div>
        <div class="text-center mt-3">
          <p class="text-subtitle-1 fs-small text-grey-darken-3">名前</p>
          <v-divider length="42" thickness="2" color="silver mt-n1" class="mx-auto"></v-divider>
          <p class="mt-2 text-body-1 fs-large">{{ user.name }}</p>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, Ref, computed, ComputedRef } from "vue"
import axios from "@/plugins/axios"
import { imageUrl } from "@/common/imageUrl"
import { useDisplay } from "vuetify"

interface Props {
  id: string
}
interface User {
  id: number
  name: string
  avatar: string
}

const props = defineProps<Props>()
const display = useDisplay()

const user: Ref<User | undefined>  = ref()

const cardWidth: ComputedRef<string | number> = computed(() => {
  if (display.xs.value) {
    return '100%'
  } else {
    return 600
  }
})


const fetchUser = async (): Promise<void> => {
  try{
    const res = await axios.get(`users/${props.id}`)
    user.value = res.data.user
  } catch(e) {
    console.log(e)
  }
}
fetchUser()


</script>

<style scoped>
.page-user{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
}

.avatar{
  border-radius: 50%;
  width: 60px;
  height: 60px;
}

.fs-large{
  font-size: 1.25rem !important;
}
.fs-small{
  font-size: 0.9rem !important;
}

</style>
