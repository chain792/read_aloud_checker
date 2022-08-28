<template>
  <v-img
    src="/top_photo.jpg"
    class="top-img "
  >
    <div class="top-main mt-10">
      <div>
        <p class="top-sub-title"><span class="ondoku-text text-deep-orange">音読</span>から始める</p>
        <p class="top-main-title text-deep-orange-accent-3">英語学習</p>
      </div>
      <v-btn 
        class="top-btn mt-10" 
        icon
        width="220"
        height="220"
        elevation="5"
        color="deep-orange"
        @click="linkToSentences"
      >
        <p class="top-btn-text">今すぐ音読する</p>
      </v-btn>
    </div>
  </v-img>
  <div>
  </div>
  <div class="usage pt-5">
    <v-container class="container">
      <div class="text-center">
        <p class="text-h4 font-weight-medium">音読スターでできること</p>
        <v-divider length="400" thickness="2" class="mx-auto my-2"></v-divider>
      </div>
      <div>
        <div class="d-flex pa-5">
          <div class="mx-12 mt-12">
            <p class="text-h5 font-weight-medium">音読してみよう</p>
            <div class="usage-description mt-3">
              音読スターで用意されている様々な英文を音読することができます。<br/>
              読み上げた英文は音声認識によりリアルタイムで反映されるため、正しい発音で音読できているか確認することができます。
            </div>
          </div>
          <div class="ml-auto">
            <v-img
              src="/usage1.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
        <div class="d-flex flex-row-reverse pa-5">
          <div class="mx-12 mt-12">
            <p class="text-h5 font-weight-medium">英文を作成してみよう</p>
            <div class="usage-description mt-3">
              音読する英文を作成することができます。<br/>
              自分好みのオリジナルな英文で音読しよう。
            </div>
          </div>
          <div class="mr-auto">
            <v-img
              src="/usage2.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
        <div class="d-flex pa-5">
          <div class="mx-12 mt-12">
            <p class="text-h5 font-weight-medium">記録を振り返ろう</p>
            <div class="usage-description mt-3">
              音読した内容は記録されます。<br/>
              音読量を可視化することでモチベーションを維持し音読を続けることができます。
            </div>
          </div>
          <div class="ml-auto">
            <v-img
              src="/usage3.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
      </div>
      <div class="my-10">
        <v-btn 
          class="mx-auto"
          color="deep-orange"
          height="50"
          @click="linkToSentences"
        >
          <p class="text-white usage-btn-text pa-1">音読を始める</p>
        </v-btn>
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
  height: calc(100vh);
  margin-top: -64px;
  position: relative;
}
.top-main{
  position: absolute;
  top: 20%;
  left: 10%;
}
.top-sub-title{
  font-size: 32px;
}
.ondoku-text{
  font-size: 38px;
  font-weight: 500;
}
.top-main-title{
  font-size: 60px;
  letter-spacing: 2px;
  font-weight: 600;
  line-height: 80px;
}
.top-btn{
}
.top-btn-text{
  font-size: 25px;
  font-weight: 600;
  color: #fff;
}
.usage-img{
  width: 300px;
  margin: 0 80px;
}
.usage{
  background-color: #f6f6f6;
}
.usage-description{
  line-height: 1.6rem;
  letter-spacing: 1px;
  max-width: 6000px;
}
.usage-btn-text{
  letter-spacing: 2px;
  font-weight: 600;
  font-size: 24px;
}
</style>
<style>
body{
  font-family: "Helvetica Neue", "Hiragino Kaku Gothic ProN", Meiryo, sans-serif;
}
</style>

