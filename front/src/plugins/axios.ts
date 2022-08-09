import axios, { AxiosInstance } from "axios"
import { silentRefresh } from "@/common/refresh"
import { useTokenStore } from "@/store/tokenStore"

const axiosInstance: AxiosInstance = axios.create({
  baseURL: `${import.meta.env.VITE_API_DOMAIN}/api/v1`,
  headers: {
    "Content-type": "application/json",
    'X-Requested-With': 'XMLHttpRequest'
  },
  withCredentials: true
})

axiosInstance.interceptors.request.use(async config => {
  await silentRefresh()
  const tokenSotre = useTokenStore()
  if(tokenSotre.accessToken){
    config.headers!['Authorization'] = `Bearer ${tokenSotre.accessToken}`
  }
  return config;
})

export default axiosInstance
