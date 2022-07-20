import { createRouter, createWebHistory, RouteRecordRaw } from "vue-router"
import TopIndex from "../pages/top/index.vue"

const TestIndex = () => import("../pages/test/index.vue")
const SignupIndex = () => import("../pages/signup/index.vue")
const LoginIndex = () => import("../pages/login/index.vue")

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "TopIndex",
    component: TopIndex,
  },
  {
    path: "/test",
    name: "TestIndex",
    component: TestIndex,
  },
  {
    path: "/signup",
    name: "SignupIndex",
    component: SignupIndex,
  },
  {
    path: "/login",
    name: "LoginIndex",
    component: LoginIndex,
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
