import { generalUser } from './factories/user';
import { createTestingPinia } from '@pinia/testing'
import { mount, VueWrapper } from '@vue/test-utils'
import Profile from '@/components/pages/profile/index.vue'
import { describe, test, expect, beforeEach } from 'vitest'
import { createVuetify } from "vuetify"
import * as components from "vuetify/components"
import * as directives from "vuetify/directives"
import router from '@/router'


describe("プロフィールページ", () => {
  const vuetify = createVuetify({ components, directives })
  let wrapper: VueWrapper<any>
  beforeEach(() => {
    wrapper = mount(Profile, {
      global: {
        plugins: [
          createTestingPinia({
            initialState: {
              user: {
                authUser: generalUser
              }
            }
          }), 
          vuetify, 
          router
        ],
      },  
    })
  })

  test('初期表示されること', () => {
    expect(wrapper.text()).toContain('プロフィール')
  })
})