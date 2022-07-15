import axios, { AxiosInstance } from "axios"

const axiosInstance: AxiosInstance = axios.create({
  baseURL: "http://localhost:8000",
  headers: {
    "Content-type": "application/json",
  },
})

export default axiosInstance
