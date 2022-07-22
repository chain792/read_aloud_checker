import { defineStore } from "pinia"

interface TokenState {
  accessToken: string
  expiredTime: number
}

export const useTokenStore = defineStore("token", {
  state: (): TokenState => ({
    accessToken: "",
    expiredTime: 0
  }),
  actions: {
    setToken(token: string, exp: number): void {
      this.accessToken = token
      this.expiredTime = exp
    }
  },
})
