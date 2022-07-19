import { defineStore } from "pinia"

interface FlashState {
  status: boolean
  message: string
  color: string
}

export const useFlashStore = defineStore("flash", {
  state: (): FlashState => ({
    status: false,
    message: "",
    color: ""
  }),
  actions: {
    succeedSignup(): void {
      this.status = true
      this.message = "ユーザー登録が完了しました"
      this.color = "green-accent-4"
    },
    failSignup(): void {
      this.status = true
      this.message = "ユーザー登録に失敗しました"
      this.color = "red-accent-3"
    },
  },
})
