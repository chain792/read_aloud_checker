<template>
  <div>
    <span 
      class="pointer text-blue-accent-4"
      @click="clickFileInput"
    >
      <v-icon color="grey-darken-2 mr-1">mdi-camera</v-icon>
      英文の画像イメージを追加
    </span>
    <v-img v-show="imageSrc" :src="imageSrc" class="preview-image mt-3" width="120px">
      <v-icon 
        class="close-icon pointer" size="x-large" color="grey-darken-3"
        @click="closeImage"
      >
        mdi-close-circle
      </v-icon>
    </v-img>
  
    <input ref="fileInput" type="file" accept="image/*" style="display: none;" @change="previewImage">
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from "vue"

interface Props {
  imageSrc: string | undefined
}
interface Emits { 
  (e: "file-change", file: File | ""): void  // eslint-disable-line no-unused-vars
}

const props = withDefaults(defineProps<Props>(), {
  imageSrc: undefined
})
const emit = defineEmits<Emits>()

const imageSrc = ref<string | undefined>()
const fileInput = ref<HTMLInputElement>()

const clickFileInput = (): void => {
  fileInput.value!.click()
}

const previewImage = (): void => {
  const file = fileInput.value!.files![0]
  const reader = new FileReader()
  reader.onloadend = (): void => {
    imageSrc.value= reader.result as string
  }
  if(file){
    emit("file-change", file)
    reader.readAsDataURL(file)
  }
}

const closeImage = (): void => {
  fileInput.value!.value = ""
  imageSrc.value = undefined
  emit("file-change", "")
}

watch(props, () => {
  console.log(props.imageSrc)
  imageSrc.value = props.imageSrc
})

</script>

<style scoped>
.pointer{
  cursor: pointer;
}

.preview-image{
  position: relative;
}

.close-icon{
  position: absolute;
  top: 3px;
  right: 3px;
}

</style>
