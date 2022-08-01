<template>
<div>
 
</div>
<div>

</div>
<div>

</div>
<div>
  {{ id }}
</div>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue"
import { useRoute } from "vue-router"
import axios from "../../plugins/axios"
import ErrorMessages from "../../components/shared/ErrorMessages.vue"
import { useUserStore }  from "../../store/userStore"
import { useFlashStore } from "../../store/flashStore"
import { useTokenStore } from "../../store/tokenStore"
import NewsSentences from "./components/NewsSentences.vue"
import UserSentences from "./components/UserSentences.vue"


const userStore = useUserStore()
const flashStore = useFlashStore()
const tokenStore = useTokenStore()


interface Props {
  id: string
}
const props = defineProps<Props>()
console.log(props.id)








</script>

<style scoped>
</style>
