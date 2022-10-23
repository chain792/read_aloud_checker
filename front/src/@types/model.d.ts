export interface Sentence {
  id: string
  title: string
  body: string
  status: "public_state" | "private_state"
  wordCount: number
  createrType: string
  createdAt: string
}