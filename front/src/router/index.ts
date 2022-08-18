import { createRouter, createWebHistory, RouteRecordRaw, RouteLocationNormalized } from "vue-router"
import TopPage from "@/components/pages/static/TopPage.vue"
import { useUserStore } from "@/store/userStore"
import { refresh, silentRefresh } from "@/common/refresh"

const SignupIndex = () => import("@/components/pages/signup/index.vue")
const LoginIndex = () => import("@/components/pages/login/index.vue")
const Sentences = () => import("@/components/pages/sentences/index.vue")
const NewSentence = () => import("@/components/pages/sentences/new.vue")
const Sentence = () => import("@/components/pages/sentences/show.vue")
const Profile = () => import("@/components/pages/profile/index.vue")
const Mypage = () => import("@/components/pages/mypage/index.vue")
const History = () => import("@/components/pages/history/show.vue")
const Privacy = () => import("@/components/pages/static/Privacy.vue")
const Terms = () => import("@/components/pages/static/Terms.vue")

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "TopPage",
    component: TopPage,
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
  {
    path: "/sentences",
    name: "Sentences",
    component: Sentences,
  },
  {
    path: "/sentences/new",
    name: "NewSentence",
    component: NewSentence,
  },
  {
    path: "/sentences/:id",
    name: "Sentence",
    component: Sentence,
    props: true
  },
  {
    path: "/profile",
    name: "Profile",
    component: Profile,
    meta: { requiresAuth: true }
  },
  {
    path: "/mypage",
    name: "Mypage",
    component: Mypage,
    meta: { requiresAuth: true }
  },
  {
    path: "/history/:id",
    name: "History",
    component: History,
    props: true,
    meta: { requiresAuth: true }
  },
  {
    path: "/privacy",
    name: "Privacy",
    component: Privacy,
  },
  {
    path: "/terms",
    name: "Terms",
    component: Terms,
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

let isFirstBeforeEach: boolean = true

router.beforeEach(async (to: RouteLocationNormalized) => {
  await silentRefresh()
  const authUser = useUserStore().authUser

  // piniaのセットアップより先に1回目のrouter.beforeEachが実行されるため1回目と2回目以降で条件を変更させる
  if(isFirstBeforeEach){
    isFirstBeforeEach = false
    const isSuccessRefresh = await refresh()
    if (to.matched.some(record => record.meta.requiresAuth) && !isSuccessRefresh ) {
      return { name: "LoginIndex" }
    }
  }else{
    if (to.matched.some(record => record.meta.requiresAuth) && !authUser) {
      return { name: "LoginIndex" }
    }
  }
})

export default router
