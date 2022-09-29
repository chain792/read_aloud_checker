import { useDisplay } from 'vuetify/lib/framework.mjs';
import { computed } from "vue"

// 600px以下
export const spScreen = computed<boolean>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return true
  } else {
    return false
  }
})

// 960px以上
export const pcScreen = computed<boolean>(() => {
  const display = useDisplay()
  if (display.xs.value || display.sm.value) {
    return false
  } else {
    return true
  }
})

export const responsiveWidth190 = computed<string | number>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return '100%'
  } else {
    return 190
  }
})

export const responsiveWidth400 = computed<string | number>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return '100%'
  } else {
    return 400
  }
})

export const responsiveWidth600 = computed<string | number>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return '100%'
  } else {
    return 600
  }
})

export const responsiveWidth800 = computed<string | number>(() => {
  const display = useDisplay()
  if (display.xs.value || display.sm.value) {
    return '100%'
  } else {
    return 800
  }
})

export const modalWidth400 = computed<number>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return display.width.value
  } else {
    return 400
  }
})

export const modalWidth500 = computed<number>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return display.width.value
  } else {
    return 500
  }
})

export const modalWidth600 = computed<number>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return display.width.value
  } else {
    return 600
  }
})

export const responsiveButtonWidth = computed<string>(() => {
  const display = useDisplay()
  if (display.xs.value) {
    return '100%'
  } else {
    return ""
  }
})