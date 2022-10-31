<template>
  <div v-show="open" class="auto-compliment" @click="open = false" ></div>
  <BaseTextField
    style="z-index: 7;"
    hide-details
    v-bind="$attrs"
    @input="open = true"
  ></BaseTextField>
  <div style="height: 70px">
    <v-card
      v-if="open && props.items.length"
      style="max-height: 70px; z-index: 10;" class="overflow-y-auto"
    >
      <v-list density="compact" class="py-1">
        <v-list-item
          v-for="(item, index) in props.items"
          :key="index"
          :value="index"
          @click="clickAutoCompliment(item)"
        >
          <v-list-item-title >{{ item }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import BaseTextField from "@/components/shared/form/BaseTextField.vue"

interface Props {
  items: string[]
}
interface Emits { 
  (e: "auto-compliment", item: string): void  // eslint-disable-line no-unused-vars
}
const props = defineProps<Props>();
const emit = defineEmits<Emits>()

const open = ref(false)

const clickAutoCompliment = (item: string) => {
  emit("auto-compliment", item)
  open.value = false
}

addEventListener
</script>

<style scoped>
.auto-compliment{
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  display: flex;
  z-index: 5;
}
</style>