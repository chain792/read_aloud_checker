<template>
  <div class="d-flex mx-sm-10">
    <v-btn
      ref="button1"
      class="ml-auto order-btn active"
      density="comfortable"
      :elevatiosn="1"
      @click="clickButton1"
    >
      <span class="btn-text">新規投稿順</span>
    </v-btn>
    <v-btn
      ref="button2"
      class="ml-5 order-btn"
      density="comfortable"
      :elevatiosn="1"
      @click="clickButton2"
      >
      <span class="btn-text">人気順</span>
    </v-btn>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import { VBtn } from "vuetify/components"

interface Emits { 
  (e: "order-by-created"): void  // eslint-disable-line no-unused-vars
  (e: "order-by-popular"): void  // eslint-disable-line no-unused-vars
}

const emit = defineEmits<Emits>()


const button1 = ref<InstanceType<typeof VBtn>>()
const button2 = ref<InstanceType<typeof VBtn>>()

const clickButton1 = (): void => {
  button2.value!.$el.classList.remove('active')
  button1.value!.$el.classList.add('active')
  emit("order-by-created")
}

const clickButton2 = (): void => {
  button1.value!.$el.classList.remove('active')
  button2.value!.$el.classList.add('active')
  emit("order-by-popular")
}

</script>

<style scoped>
.btn-text{
  font-size: 0.95rem !important;
}

.order-btn {
  background-color: #eee;
}

.active {
  background-color: #fb901d;
  color: #fff;
  font-weight: 500;
}

</style>
