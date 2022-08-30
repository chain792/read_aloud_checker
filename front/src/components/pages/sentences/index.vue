<template>
  <div class="page-sentences">
    <v-container class="pt-0">
      <div class="tab-menu mb-6">
        <div ref="tabItem1" class="tab-menu-item pa-2" @click="changeTab(0)">
          <v-icon>mdi-newspaper</v-icon><span>おすすめの英文</span>
        </div>
        <div ref="tabItem2" class="tab-menu-item pa-2" @click="changeTab(1)">
          <v-icon>mdi-account-multiple</v-icon><span>みんなが投稿した英文</span>
        </div>
      </div>

      <div class="tab-content">
        <div v-show="tab === 0">
          <NewsSentences />
        </div>
        <div v-show="tab === 1">
          <UserSentences />
        </div>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref, Ref, onMounted } from "vue"
import NewsSentences from "./components/NewsSentences.vue"
import UserSentences from "./components/UserSentences.vue"

const initilaTabValue: string = sessionStorage.sentencesTab ? sessionStorage.sentencesTab : "1"
const tab: Ref<number> = ref(Number(initilaTabValue))
const tabItem1 = ref<HTMLDivElement>()
const tabItem2 = ref<HTMLDivElement>()
const tabItems = [tabItem1, tabItem2]

const changeTab = (n: number): void => {
  tabItems.forEach(item => {
    item.value!.classList.remove('active')
  })
  tabItems[n].value!.classList.add("active")
  tab.value = n
  sessionStorage.sentencesTab = n
}

onMounted(() => {
  changeTab(tab.value)
})


</script>

<style scoped>
.page-sentences {
  background-color: rgba(225, 200, 30, 0.1);
}

.tab-menu {
  display: flex;
  justify-content: center;
}

.tab-menu-item {
  width: 40%;
  text-align: center;
  border: 1px solid #ddd;
  background-color: #eee;
  vertical-align: bottom;
}

.active {
  background-color: #fb901d;
  color: #fff;
  font-weight: 500;
}

.tab-menu-item > span{
  vertical-align: bottom;
}

@media (min-width: 1920px) {
  .tab-content, .tab-menu{
    margin: 0 200px;
  }
}
</style>
