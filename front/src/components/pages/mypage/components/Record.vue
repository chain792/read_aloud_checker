<template>
  8月
  <GChart
    type="ColumnChart"
    :data="chartData"
    :options="chartOptions"
  />
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import { GChart } from 'vue-google-charts'
import axios from "@/plugins/axios"

interface MonthlyRecord {
  succeededNumber: number
  failedNumber: number
}

const chartData: any[][] = reactive([
  ['日', '音読した単語数', 'ミスした単語数'],
])

const fetchRecord = async (year: number, month: number): Promise<void> => {
  try{
    const res = await axios.get(`user/trainings`, {
      params: {
        year,
        month
      }
    })
    res.data.forEach((v: MonthlyRecord, i: number) => {
      chartData.push([`${month}/${i+1}`, v.succeededNumber, v.failedNumber])
    })
  } catch(e) {
    console.log(e)
  }
}
fetchRecord(2022, 8)



const chartOptions = {
  isStacked: true,
}
</script>

<style scoped>
</style>
