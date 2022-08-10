import axios from "axios"
import { useUserStore } from "@/store/userStore"
import { useTokenStore } from "@/store/tokenStore"

export async function refresh(): Promise<void> {
  const tokenStore = useTokenStore()
  const userStore = useUserStore()
  try {
    const res = await axios.post(`${import.meta.env.VITE_API_DOMAIN}/api/v1/refresh`, "", {
      headers: {
        "Content-type": "application/json",
        'X-Requested-With': 'XMLHttpRequest'
      },
      withCredentials: true
    })
    console.log(res)
    userStore.setUser(JSON.parse(res.data.user))
    tokenStore.setToken(res.data.token, res.data.expiredTime)
  } catch(e) {
    console.log(e)
    userStore.$reset()
    tokenStore.$reset()
  }
}

export async function silentRefresh(): Promise<void> {
  const tokenStore = useTokenStore()
  const userStore = useUserStore()
  if (userStore.authUser && tokenStore.expiredTime * 1000 < new Date().getTime()) {
    await refresh()
  }
}
