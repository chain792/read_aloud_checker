import { createRouter, createWebHistory, RouteRecordRaw, RouteLocationNormalized } from "vue-router"
import TopIndex from "../pages/top/index.vue"
import { useUserStore } from "../store/userStore"

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
    meta: { requiresAuth: true }
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

router.beforeEach((to: RouteLocationNormalized) => {
  const authUser = useUserStore().authUser
  if (to.matched.some(record => record.meta.requiresAuth) && !authUser) {
    return { name: "LoginIndex" }
  }
})

export default router
