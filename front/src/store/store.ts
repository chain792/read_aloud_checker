import { defineStore } from "pinia"

interface State {
  hello: string
}

export const useStore = defineStore("app", {
  state: (): State => ({
    hello: "hello world",
  }),
  actions: {},
})
