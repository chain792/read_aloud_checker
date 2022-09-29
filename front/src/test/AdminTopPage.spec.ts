import { createTestingPinia } from '@pinia/testing'
import { mount, VueWrapper } from '@vue/test-utils'
import AdminTopPage from '@/components/pages/admin/static/TopPage.vue'
import { describe, test, expect, beforeEach } from 'vitest'
import { createVuetify } from "vuetify"
import * as components from "vuetify/components"
import * as directives from "vuetify/directives"
import router from '@/router'
import { adminUser } from './factories/user'


describe("管理画面トップページ", () => {
  const vuetify = createVuetify({ components, directives })
  let wrapper: VueWrapper<any>
  beforeEach(() => {
    wrapper = mount(AdminTopPage, {
      global: {
        plugins: [
          createTestingPinia({
            initialState: {
              user: {
                authUser: adminUser
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
    expect(wrapper.text()).toContain('ダッシュボード')
  })
})