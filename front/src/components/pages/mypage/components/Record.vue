<template>
  <v-card class="pt-2 py-5">
    <div class="mt-5 d-flex">
      <div class="ml-16">
        <p class="mt-2">期間：</p>
      </div>
      <div class="select-container">
        <v-select
          v-model="itemValue"
          :items="items"
          variant="solo"
          density="compact"
        ></v-select>
      </div>
    </div>
    <div class="mt-6">
      <p class="ml-16">合計音読数： <span class="mr-1 text-h4">{{ totalSucceededNumber }}</span>単語</p>
      <p class="ml-16">発音精度： {{ precision }}<span v-if="precision !== 'ー'">%</span></p>
    </div>
    <GChart
      type="ColumnChart"
      :data="chartData"
      :options="chartOptions"
    />
  </v-card>
</template>

<script setup lang="ts">
import { ref, reactive, watch, Ref } from "vue"
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

const totalSucceededNumber = ref(0)
const precision: Ref<string | number> = ref(100)
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
  ['日', '音読した単語', 'ミスした単語'],
])

const fetchRecord = async (year: number | string, month: number | string): Promise<void> => {
  try{
    const res = await axios.get(`user/records`, {
      params: {
        year,
        month
      }
    })
    totalSucceededNumber.value = 0
    let totalFailedNumber = 0
    chartData.splice(1)
    res.data.forEach((v: MonthlyRecord, i: number) => {
      chartData.push([`${month}/${i+1}`, v.succeededNumber, v.failedNumber])
      totalSucceededNumber.value += v.succeededNumber
      totalFailedNumber += v.failedNumber
    })
    precision.value = (totalSucceededNumber.value + totalFailedNumber) === 0 ? 
      'ー' : Math.round(totalSucceededNumber.value * 100 / (totalSucceededNumber.value + totalFailedNumber))
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
  height: 40px;
}
</style>
<style>
.select-container .v-field__field{
  padding-top: 2px !important;
}
</style>
