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
    playReadAloud(): void {
      this.status = true
      this.message = "音読を開始しました"
      this.color = "green-accent-4"
    },
    finishReadAloud(): void {
      this.status = true
      this.message = "音読を終了しました"
      this.color = "green-accent-4"
    },
    succeedUpdateProfile(): void {
      this.status = true
      this.message = "プロフィールを編集しました"
      this.color = "green-accent-4"
    },
    failUpdateProfile(): void {
      this.status = true
      this.message = "プロフィールの編集に失敗しました"
      this.color = "red-accent-3"
    },
    succeedUpdateEmail(): void {
      this.status = true
      this.message = "メールアドレスを変更しました"
      this.color = "green-accent-4"
    },
    failUpdateEmail(): void {
      this.status = true
      this.message = "メールアドレスの変更に失敗しました"
      this.color = "red-accent-3"
    },
    succeedUpdatePassword(): void {
      this.status = true
      this.message = "パスワードを変更しました"
      this.color = "green-accent-4"
    },
    failUpdatePassword(): void {
      this.status = true
      this.message = "パスワードの変更に失敗しました"
      this.color = "red-accent-3"
    },
    succeedResetPassword(): void {
      this.status = true
      this.message = "パスワードを変更しました"
      this.color = "green-accent-4"
    },
    succeedSendEmail(): void {
      this.status = true
      this.message = "メールを送信しました"
      this.color = "green-accent-4"
    },
    failResetPassword(): void {
      this.status = true
      this.message = "パスワードの変更に失敗しました"
      this.color = "red-accent-3"
    },
    failVerifyToken(): void {
      this.status = true
      this.message = "無効なURLです"
      this.color = "red-accent-3"
    },
    chengedSpeechVoiceToMale(): void {
      this.status = true
      this.message = "男性のボイスに変更しました"
      this.color = "blue-lighten-2"
    },
    chengedSpeechVoiceToFemale(): void {
      this.status = true
      this.message = "女性のボイスに変更しました"
      this.color = "pink-accent-1"
    },
  },
})
