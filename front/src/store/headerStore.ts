import { defineStore } from "pinia"

interface HeaderState {
  isOpacity: boolean
}

export const useHeaderStore = defineStore("header", {
  state: (): HeaderState => ({
    isOpacity: false,
  }),
  actions: {
    opacity(): void {
      this.isOpacity = true
    },
    disOpacity(): void {
      this.isOpacity = false
    },
  },
})
