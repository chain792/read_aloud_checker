import { createRouter, createWebHistory, RouteRecordRaw, RouteLocationNormalized } from "vue-router"
import TopPage from "@/components/pages/static/TopPage.vue"
import DefaultLayout from "@/components/layouts/Default.vue"
import AdminLayout from "@/components/layouts/Admin.vue"
import { useUserStore } from "@/store/userStore"
import { refresh, silentRefresh } from "@/common/refresh"

const Signup = () => import("@/components/pages/signup/index.vue")
const Login = () => import("@/components/pages/login/index.vue")
const UserSentences = () => import("@/components/pages/sentences/user/index.vue")
const NewsSentences = () => import("@/components/pages/sentences/news/index.vue")
const NewSentence = () => import("@/components/pages/sentences/new.vue")
const Sentence = () => import("@/components/pages/sentences/show.vue")
const EditSentence = () => import("@/components/pages/sentences/edit.vue")
const BookmarkSentences = () => import("@/components/pages/sentences/bookmark.vue")
const User = () => import("@/components/pages/users/show.vue")
const Profile = () => import("@/components/pages/profile/index.vue")
const MyHistory = () => import("@/components/pages/mypage/history/index.vue")
const MyRecord = () => import("@/components/pages/mypage/record/index.vue")
const MySentences = () => import("@/components/pages/mypage/sentences/index.vue")
const History = () => import("@/components/pages/history/show.vue")
const Privacy = () => import("@/components/pages/static/Privacy.vue")
const Terms = () => import("@/components/pages/static/Terms.vue")
const NewPasswordReset = () => import("@/components/pages/password_resets/new.vue")
const PasswordResetSent = () => import("@/components/pages/password_resets/sent.vue")
const EditPasswordReset = () => import("@/components/pages/password_resets/edit.vue")
const AdminTopPage = () => import("@/components/pages/admin/static/TopPage.vue")
const AdminLogin = () => import("@/components/pages/admin/login/index.vue")
const AdminUsers = () => import("@/components/pages/admin/users/index.vue")

const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    component: DefaultLayout,
    children: [
      {
        path: "",
        name: "TopPage",
        component: TopPage
      },
      {
        path: "signup",
        name: "Signup",
        component: Signup
      },
      {
        path: "login",
        name: "Login",
        component: Login,
      },
      {
        path: "sentences/users",
        name: "UserSentences",
        component: UserSentences,
      },
      {
        path: "sentences/news",
        name: "NewsSentences",
        component: NewsSentences,
      },
      {
        path: "sentences/new",
        name: "NewSentence",
        component: NewSentence,
      },
      {
        path: "sentences/:id",
        name: "Sentence",
        component: Sentence,
        props: true
      },
      {
        path: "sentences/:id/edit",
        name: "EditSentence",
        component: EditSentence,
        props: true,
        meta: { requiresAuth: true }
      },
      {
        path: "sentences/bookmark",
        name: "BookmarkSentences",
        component: BookmarkSentences,
        meta: { requiresAuth: true }
      },
      {
        path: "users/:id",
        name: "User",
        component: User,
        props: true
      },
      {
        path: "profile",
        name: "Profile",
        component: Profile,
        meta: { requiresAuth: true }
      },
      {
        path: "mypage/history",
        name: "MyHistory",
        component: MyHistory,
        meta: { requiresAuth: true }
      },
      {
        path: "mypage/record",
        name: "MyRecord",
        component: MyRecord,
        meta: { requiresAuth: true }
      },
      {
        path: "mypage/sentences",
        name: "MySentences",
        component: MySentences,
        meta: { requiresAuth: true }
      },
      {
        path: "history/:id",
        name: "History",
        component: History,
        props: true,
        meta: { requiresAuth: true }
      },
      {
        path: "privacy",
        name: "Privacy",
        component: Privacy,
      },
      {
        path: "terms",
        name: "Terms",
        component: Terms,
      },
      {
        path: "password_resets/new",
        name: "NewPasswordReset",
        component: NewPasswordReset,
      },
      {
        path: "password_resets/sent",
        name: "PasswordResetSent",
        component: PasswordResetSent,
      },
      {
        path: "password_resets/:id/edit",
        name: "EditPasswordReset",
        component: EditPasswordReset,
        props: true,
      },
    ]
  },
  {
    path: "/admin/login",
    name: "AdminLogin",
    component: AdminLogin,
  },
  {
    path: "/admin",
    component: AdminLayout,
    children: [
      {
        path: "",
        name: "AdminTopPage",
        component: AdminTopPage,
        meta: { requiresAdmin: true }
      },
      {
        path: "users",
        name: "AdminUsers",
        component: AdminUsers,
        meta: { requiresAdmin: true }
      },
    ]
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
      return { name: "Login" }
    }
    if (to.matched.some(record => record.meta.requiresAdmin) && (!isSuccessRefresh || isSuccessRefresh !== 'admin')) {
      return { name: "AdminLogin" }
    }
  }else{
    if (to.matched.some(record => record.meta.requiresAuth) && !authUser) {
      return { name: "Login" }
    }
    if (to.matched.some(record => record.meta.requiresAdmin) && (!authUser || authUser.role !== 'admin')) {
      return { name: "AdminLogin" }
    }
  }
})

export default router
