export const nameRules = [
  (v: string) => !!v || '名前を入力してください',
  (v: string) => (v && v.length <= 50) || '50文字以内で入力してください' 
]

export const emailRules = [
  (v: string) => !!v || 'メールアドレスを入力してください',
  (v: string) => /.+@.+\..+/.test(v) || 'メールアドレスの形式が正しくありません',
]

export const passwordRules = [
  (v: string) => !!v || 'パスワードを入力してください',
  (v: string) => (v && v.length >= 6) || '6文字以上で入力してください',
]

export const titleRules = [
  (v: string) => !!v || 'タイトルを入力してください',
  (v: string) => (v && v.length <= 100) || '100文字以内で入力してください' 
]

export const bodyRules = [
  (v: string) => !!v || '本文を入力してください',
  (v: string) => (v && v.length <= 10000) || '10000文字以内で入力してください' 
]