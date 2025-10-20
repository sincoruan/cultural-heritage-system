import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import { useUserStore } from '@/store/user'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

NProgress.configure({ showSpinner: false })

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    redirect: '/home',
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录', requiresAuth: false },
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue'),
    meta: { title: '注册', requiresAuth: false },
  },
  {
    path: '/home',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
    meta: { title: '首页', requiresAuth: false },
  },
  {
    path: '/heritage',
    name: 'Heritage',
    component: () => import('@/views/Heritage/List.vue'),
    meta: { title: '文化遗产', requiresAuth: false },
  },
  {
    path: '/heritage/:id',
    name: 'HeritageDetail',
    component: () => import('@/views/Heritage/Detail.vue'),
    meta: { title: '文化遗产详情', requiresAuth: false },
  },
  {
    path: '/multimedia',
    name: 'Multimedia',
    component: () => import('@/views/Multimedia.vue'),
    meta: { title: '多媒体展示', requiresAuth: false },
  },
  {
    path: '/notice',
    name: 'Notice',
    component: () => import('@/views/Notice/List.vue'),
    meta: { title: '公告通知', requiresAuth: false },
  },
  {
    path: '/notice/:id',
    name: 'NoticeDetail',
    component: () => import('@/views/Notice/Detail.vue'),
    meta: { title: '公告详情', requiresAuth: false },
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/User/Profile.vue'),
    meta: { title: '个人中心', requiresAuth: true },
  },
  {
    path: '/interactive',
    name: 'Interactive',
    component: () => import('@/views/Interactive.vue'),
    meta: { title: '互动交流', requiresAuth: true },
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/views/Admin/Layout.vue'),
    meta: { title: '管理后台', requiresAuth: true, requiresAdmin: true },
    redirect: '/admin/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Admin/Dashboard.vue'),
        meta: { title: '数据统计' },
      },
      {
        path: 'heritage',
        name: 'AdminHeritage',
        component: () => import('@/views/Admin/Heritage/List.vue'),
        meta: { title: '文化遗产管理' },
      },
      {
        path: 'notice',
        name: 'AdminNotice',
        component: () => import('@/views/Admin/Notice/List.vue'),
        meta: { title: '公告管理' },
      },
      {
        path: 'user',
        name: 'AdminUser',
        component: () => import('@/views/Admin/User/List.vue'),
        meta: { title: '用户管理' },
      },
      {
        path: 'monitor',
        name: 'AdminMonitor',
        component: () => import('@/views/Admin/Monitor.vue'),
        meta: { title: '系统监控' },
      },
    ],
  },
  {
    path: '/403',
    name: 'Forbidden',
    component: () => import('@/views/Forbidden.vue'),
    meta: { title: '403' },
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '404' },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// 路由守卫
router.beforeEach((to, from, next) => {
  NProgress.start()

  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - 文化遗产管理与展示系统`
  }

  const userStore = useUserStore()
  const isAuthenticated = userStore.isAuthenticated

  // 需要登录的页面
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({
      path: '/login',
      query: { redirect: to.fullPath },
    })
    return
  }

  // 需要管理员权限的页面
  if (to.meta.requiresAdmin && !userStore.isAdmin) {
    next({ path: '/403' })
    return
  }

  next()
})

router.afterEach(() => {
  NProgress.done()
})

export default router

