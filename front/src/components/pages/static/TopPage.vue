<template>
  <div ref="topDiv">
    <v-img
      src="/top_photo.jpg"
      class="top-img"
    >
      <div v-show="pcScreen" class="top-main mt-10">
        <div>
          <p class="top-sub-title"><span class="ondoku-text text-deep-orange">音読</span>から始める</p>
          <p class="top-main-title text-deep-orange-accent-3">英語学習</p>
        </div>
        <v-btn 
          class="mt-10" 
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
    <div v-show="!pcScreen">
      <div v-show="display.sm.value" class="text-center mt-5">
        <p class="top-sub-title font-weight-bold"><span class="ondoku-text font-weight-bold text-deep-orange">音読</span>から始める<span class="ondoku-text font-weight-bold text-deep-orange">英語学習</span></p>
      </div>
      <div v-show="display.xs.value" class="text-center mt-5">
        <p class="top-sub-title font-weight-bold"><span class="ondoku-text text-deep-orange font-weight-bold">音読</span>から始める</p>
        <p class="top-main-title text-deep-orange-accent-3">英語学習</p>
      </div>
      <v-btn 
        class="mx-auto mt-5 mb-10" 
        rounded
        height="50"
        elevation="5"
        color="deep-orange"
        @click="linkToSentences"
      >
        <p class="top-btn-text">今すぐ音読する</p>
      </v-btn>
    </div>
  </div>
  <div class="usage pt-5">
    <v-container class="container">
      <div class="text-center">
        <p class="text-h4 font-weight-bold">音読スターでできること</p>
        <v-divider length="400" thickness="2" class="mx-auto my-2"></v-divider>
      </div>
      <div class="usage-container">
        <div ref="usageDiv1" class="d-md-flex px-lg-5 usage-disappear">
          <div class="mt-md-12">
            <p class="text-h5 font-weight-bold text-center">音読してみよう</p>
            <div class="usage-description mt-3 text-center">
              音読スターで用意されている様々な英文を音読することができます。<br/>
              読み上げた英文は音声認識によりリアルタイムで反映されるため、正しい発音で音読できているか確認することができます。
            </div>
          </div>
          <div class="ml-md-auto mx-md-16">
            <v-img
              src="/usage1.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
        <div ref="usageDiv2" class="d-md-flex flex-row-reverse px-lg-5  mt-md-3  usage-disappear">
          <div class="mt-md-12">
            <p class="text-h5 font-weight-bold text-center">英文を作成してみよう</p>
            <div class="usage-description mt-3 text-center">
              音読する英文を作成することができます。<br/>
              自分好みのオリジナルな英文で音読することができます。
            </div>
          </div>
          <div class="mr-md-auto ml-md-16">
            <v-img
              src="/usage2.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
        <div ref="usageDiv3" class="d-md-flex px-lg-5 mt-md-3 usage-disappear">
          <div class="mt-md-12">
            <p class="text-h5 font-weight-bold text-center">記録を振り返ろう</p>
            <div class="usage-description mt-3 text-center">
              音読した内容は記録されます。<br/>
              音読量を可視化することでモチベーションを維持し音読を続けることができます。
            </div>
          </div>
          <div class="ml-md-auto mr-md-16">
            <v-img
              src="/usage3.png"
              class="usage-img"
            >
            </v-img>
          </div>
        </div>
      </div>
      <div class="mt-14 mb-10">
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
import { computed, ComputedRef, ref, onMounted } from "vue"
import { useDisplay } from "vuetify"
import { useRouter } from "vue-router";
import { useHeaderStore } from "@/store/headerStore"

const router = useRouter()
const headerStore = useHeaderStore()
const display = useDisplay()

headerStore.opacity()

//960px以上
const pcScreen: ComputedRef<boolean> = computed(() => {
  if (display.xs.value || display.sm.value) {
    return false
  } else {
    return true
  }
})

const linkToSentences = (): void => {
  router.push({ name: "Sentences" })
}

/***************************************************
  Intersection Observer API
 ***************************************************/
const usageDiv1 = ref<HTMLDivElement>()
const usageDiv2 = ref<HTMLDivElement>()
const usageDiv3 = ref<HTMLDivElement>()
const topDiv = ref<HTMLDivElement>()

const callbackAnimation = (entries: Array<IntersectionObserverEntry>, obs: IntersectionObserver) => {
  entries.forEach(entry => {
    if(!entry.isIntersecting) return
    
    entry.target.classList.add('usage-appear')
    obs.unobserve(entry.target)
  })
}

const callbackHeaderChange = (entries: Array<IntersectionObserverEntry>) => {
  entries.forEach(entry => {
    if(entry.isIntersecting){
      headerStore.opacity()
    }else{
      headerStore.disOpacity()
    }
  })
}

const observer = new IntersectionObserver(callbackAnimation, {
  threshold: 0.3
})
const imgObserver = new IntersectionObserver(callbackHeaderChange, {
  threshold: 0
})

onMounted(() => {
  observer.observe(usageDiv1.value!)
  observer.observe(usageDiv2.value!)
  observer.observe(usageDiv3.value!)
  imgObserver.observe(topDiv.value!)
})


</script>

<style scoped>
.top-img{
  left: -10%;
}
.top-sub-title{
  font-size: 32px;
}
.ondoku-text{
  font-size: 38px;
  font-weight: 500;
}
.top-main-title{
  font-size: 55px;
  letter-spacing: 2px;
  font-weight: 600;
  line-height: 80px;
}
.top-btn-text{
  font-size: 25px;
  font-weight: 600;
  color: #fff;
}
.usage-img{
  width: 400px;
  margin: 0 auto;
}
.usage{
  background-color: #f6f6f6;
}
.usage-description{
  font-size: 18px;
  line-height: 1.6rem;
  letter-spacing: 1px;
}
.usage-btn-text{
  letter-spacing: 2px;
  font-weight: 600;
  font-size: 24px;
}
@media (min-width: 600px) {
  .usage-container{
    margin: 0 50px;
  }
}
@media (min-width: 960px) {
  .top-img{
    height: calc(85vh);
    margin-top: -64px;
    position: relative;
    left: 0%;
  }
  .top-main{
    position: absolute;
    top: 20%;
    left: 10%;
  }
  .top-sub-title{
    font-size: 32px;
  }
  .top-main-title{
    font-size: 60px;
  }
  .usage-img{
    width: 300px;
    margin: 0 80px;
  }
}
@media (min-width: 1280px) {
  .top-img{
    height: calc(100vh);
  }
  .usage-container{
    margin: 0 100px;
  }
}
@media (min-width: 1904px) {
  .usage-container{
    margin: 0 250px;
  }
}
</style>
<style>
.usage-disappear{
  opacity: 0;
  transform: translateY(30px);
  transition: opacity .4s, transform .4s;
}
.usage-appear{
  opacity: 1;
  transform: translateY(0);
}
</style>
