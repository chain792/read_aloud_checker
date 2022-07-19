import { defineStore } from "pinia"

interface User {
  id: number
  email: string
  name: string
  avatar: string
  createdAt: string
  updatedAt: string
}

interface UserState {
  authUser: User | null
}

export const useUserStore = defineStore("user", {
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
