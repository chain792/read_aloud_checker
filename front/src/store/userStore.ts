import { defineStore } from "pinia"

interface User {
  id: number
  email: string
  name: string
  avatar: string
  created_at: string
  updated_at: string
}

interface UserState {
  authUser: User | null
}

export const useUserStore = defineStore("app", {
  state: (): UserState => ({
    authUser: null
  }),
  actions: {
    setUser(user: User): void {
      this.authUser = user
      console.log(this.authUser)
    }
  },
})
