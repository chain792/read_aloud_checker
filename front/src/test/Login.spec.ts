import { createTestingPinia } from '@pinia/testing'
import { mount, VueWrapper } from '@vue/test-utils'
import Login from '@/components/pages/login/index.vue'
import { describe, test, expect, beforeEach } from 'vitest'
import { createVuetify } from "vuetify"
import * as components from "vuetify/components"
import * as directives from "vuetify/directives"


describe("ログインページ", () => {
  const vuetify = createVuetify({ components, directives })
  let wrapper: VueWrapper<any>
  beforeEach(() => {
    wrapper = mount(Login, {
      global: {
        plugins: [createTestingPinia(), vuetify],
      },
    })
  })

  test('初期表示されること', () => {
    expect(wrapper.text()).toContain('ログイン')
  })
})