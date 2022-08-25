import { defineStore } from "pinia"

interface User {
  id: number
  email: string
  name: string
  avatar: string
  listeningSex: "male" | "female" | undefined
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
    },
    changeListeningSexToMale(): void {
      this.authUser!.listeningSex = "male"
    },
    changeListeningSexToFemale(): void {
      this.authUser!.listeningSex = "female"
    },
  },
})
