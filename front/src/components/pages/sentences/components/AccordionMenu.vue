<template>
  <div class="accordion mb-5">
    <span 
      class="accordion-title py-2 pr-3"
      @click="isAccordion = !isAccordion"
    >  
      <span class="text-grey-darken-2 d-inline-block" :class="{'open': isAccordion === true}">▼</span> 
      その他の設定
    </span>
    <div v-show="isAccordion" class="accordion-menu mt-5">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"

const isAccordion = ref(false)

</script>

<style scoped>
.accordion-title{
  cursor: pointer;
  user-select: none;
}

.accordion-title > span{
  transition: transform .3s;
}
.accordion-title > span.open{
  transform: rotate(60deg);
}

</style>
