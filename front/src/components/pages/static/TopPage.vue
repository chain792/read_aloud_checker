<template>
  <v-img
    src="/top_photo.jpg"
    class="top-img"
  >
    <div>
      <p>音読から始める</p>
      <p>英語学習</p>
    </div>
    <v-btn @click="linkToSentences">今すぐ音読する</v-btn>
  </v-img>
  <div>
  </div>
  <div class="usage">
    <v-container class="container">
      <div class="text-center">
        <p>音読スターでできること</p>
      </div>
      <div>
        <div class="d-flex">
          <p class="">音読できるよ</p>
          <div>
            <v-img
              src="/usage1.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
        <div class="d-flex flex-row-reverse">
          <p class="">記録できるよ</p>
          <div >
            <v-img
              src="/usage2.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
      </div>
      <div class="">
        <v-btn class="mx-auto" @click="linkToSentences">音読を始める</v-btn>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from "vue"
import { useDisplay } from "vuetify"
import { useRouter } from "vue-router";

const router = useRouter()

const display = useDisplay()
const a = computed(() => {
  if (display.md.value) {
    return "large"
  } else {
    return "small"
  }
})

const linkToSentences = (): void => {
  router.push({ name: "Sentences" })
}


</script>

<style scoped>
.top-img{
  height: calc(100vh - 64px);
}
.usage-img{
  width: 300px;
}
.usage{
  background-color: #f6f6f6;
}
</style>

