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
                authUser: {
                  id: 1,
                  email: 'test@example.com',
                  emailStatus: "unverified",
                  name: 'test',
                  avatar: '',
                  role: "general",
                  listeningSex: "male",
                  createdAt: "2022",
                  updatedAt: "2022"
                }
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