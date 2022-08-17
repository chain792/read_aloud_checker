<template>
  <div class="select-container mt-5">
    <v-select
      v-model="itemValue"
      :items="items"
      variant="solo"
      density="comfortable"
    ></v-select>
  </div>
  <GChart
    type="ColumnChart"
    :data="chartData"
    :options="chartOptions"
  />
</template>

<script setup lang="ts">
import { ref, reactive, watch } from "vue"
import { GChart } from 'vue-google-charts'
import axios from "@/plugins/axios"
import { useUserStore } from "@/store/userStore"


interface MonthlyRecord {
  succeededNumber: number
  failedNumber: number
}
interface Item {
  title: string
  value: string
}

const date = new Date()
const currentYear = date.getFullYear()
const currentMonth = date.getMonth() + 1
const [registerdYear, registerdMonth] = useUserStore().authUser!.createdAt.split('-')
const diffYear = currentYear - Number(registerdYear)
const diffMonth = currentMonth - Number(registerdMonth)
const itemNumber = diffYear * 12 + diffMonth + 1
const items: Array<Item> = reactive([])
let dy = 0
let dm = 0
for(let i = 0; i < itemNumber; i++) {
  items.push({
    title: `${currentYear - dy}年${currentMonth - dm}月`,
    value: `${currentYear - dy}-${currentMonth - dm}`
  })
  if(currentMonth - dm < 1){
    dy += 1
    dm -= 12
  }else{
    dm += 1
  }
}
const itemValue = ref(`${currentYear}-${currentMonth}`)

watch(itemValue, () => {
  const [year, month] = itemValue.value.split('-')
  fetchRecord(year, month)
})


const chartData: any[][] = reactive([
  ['日', '音読した単語数', 'ミスした単語数'],
])

const fetchRecord = async (year: number | string, month: number | string): Promise<void> => {
  try{
    const res = await axios.get(`user/trainings`, {
      params: {
        year,
        month
      }
    })
    chartData.splice(1)
    res.data.forEach((v: MonthlyRecord, i: number) => {
      chartData.push([`${month}/${i+1}`, v.succeededNumber, v.failedNumber])
    })
  } catch(e) {
    console.log(e)
  }
}
fetchRecord(currentYear, currentMonth)



const chartOptions = {
  isStacked: true,
}
</script>

<style scoped>
.select-container{
  width: 160px;
}
</style>
