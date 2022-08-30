<template>
  <div class="page-mypage">
    <v-container>
      <div class="tab-menu mb-6">
        <div ref="tabItem1" class="tab-menu-item pa-2" @click="changeTab(0)">
          <v-icon>mdi-chart-bar</v-icon><span>音読記録</span>
        </div>
        <div ref="tabItem2" class="tab-menu-item pa-2" @click="changeTab(1)">
          <v-icon>mdi-book-open</v-icon><span>音読履歴</span>
        </div>
      </div>

      <div class="tab-content">
        <div v-show="tab === 0">
          <Record />
        </div>
        <div v-show="tab === 1">
          <Histories />
        </div>
      </div>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { ref, Ref, onMounted } from "vue"
import Record from "./components/Record.vue"
import Histories from "./components/Histories.vue"

const initilaTabValue: string = sessionStorage.mypageTab ? sessionStorage.mypageTab : "0"
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
  sessionStorage.mypageTab = n
}

onMounted(() => {
  changeTab(tab.value)
})

</script>

<style scoped>
.page-mypage{
  background-color: rgba(225, 200, 30, 0.1);
  height: 100%;
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
