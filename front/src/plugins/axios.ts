import axios, { AxiosInstance } from "axios"
import { silentRefresh } from "../common/refresh"

const axiosInstance: AxiosInstance = axios.create({
  baseURL: "http://localhost:8000/api/v1",
  headers: {
    "Content-type": "application/json",
  },
  withCredentials: true
})

axiosInstance.interceptors.request.use(async config => {
  await silentRefresh()
  return config;
})

export default axiosInstance
