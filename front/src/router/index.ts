import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router"
import TopIndex from '../pages/top/index.vue'

const TestIndex = () => import('../pages/test/index.vue')

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'TopIndex',
    component: TopIndex
  },
  {
    path: '/test',
    name: 'TestIndex',
    component: TestIndex
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router