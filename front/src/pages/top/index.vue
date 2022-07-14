<template>
  <div>トップページです</div>
  <div>{{ store.hello }}</div>
  <v-btn
    flat
    color="secondary"
    :size="a"
    class="ma-lg-5"
  >
    Secondary
  </v-btn>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useStore } from '../../store/store';
import { useDisplay } from 'vuetify'
const store = useStore()
const display = useDisplay()
console.log(display.md) // 1280
const a = computed(() => {
  console.log('con')
  if(display.md.value){
    return 'large'
  }else{
    return 'small'
  }
})
</script>

<style scoped>
</style>
