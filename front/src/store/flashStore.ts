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
    succeedLogin(): void {
      this.status = true
      this.message = "ログインしました"
      this.color = "green-accent-4"
    },
    failLogin(): void {
      this.status = true
      this.message = "ログインに失敗しました"
      this.color = "red-accent-3"
    },
    succeedLogout(): void {
      this.status = true
      this.message = "ログアウトしました"
      this.color = "green-accent-4"
    },
    failLogout(): void {
      this.status = true
      this.message = "ログアウトに失敗しました"
      this.color = "red-accent-3"
    },
    succeedCreateSentences(): void {
      this.status = true
      this.message = "英文を作成しました"
      this.color = "green-accent-4"
    },
    failCreateSentences(): void {
      this.status = true
      this.message = "英文の作成に失敗しました"
      this.color = "red-accent-3"
    },
  },
})
