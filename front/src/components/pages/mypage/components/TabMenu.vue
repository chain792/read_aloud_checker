<template>
  <div class="tab-menu mb-6">
    <div ref="tabItem1" class="tab-menu-item pa-2" @click="linkToMyRecord">
      <v-icon>mdi-chart-bar</v-icon><span>音読記録</span>
    </div>
    <div ref="tabItem2" class="tab-menu-item pa-2" @click="linkToMyHistory">
      <v-icon>mdi-book-open</v-icon><span>音読履歴</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue"
import { useRouter } from "vue-router"

interface Props {
  tab: number
}
const props = defineProps<Props>()
const router = useRouter()

const tabItem1 = ref<HTMLDivElement>()
const tabItem2 = ref<HTMLDivElement>()
const tabItems = [tabItem1, tabItem2]

onMounted(() => {
  tabItems[props.tab].value!.classList.add("active")
})

const linkToMyRecord = (): void => {
  router.push({ name: 'MyRecord' })
}

const linkToMyHistory = (): void => {
  router.push({ name: 'MyHistory' })
}

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
  cursor: pointer;
}

.active {
  background-color: #fb901d;
  color: #fff;
  font-weight: 500;
  cursor: default
}

.tab-menu-item > span{
  vertical-align: bottom;
}
</style>
