import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import { supabase } from '../lib/supabase'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('../views/Profile.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/auth/callback',
    name: 'AuthCallback',
    component: Home,
    beforeEnter: async (to) => {
      try {
        const { error } = await supabase.auth.getSession()
        if (error) throw error
        
        const hashParams = new URLSearchParams(window.location.hash.substring(1))
        if (hashParams.has('access_token')) {
          return { path: '/profile' }
        }
        
        return { path: '/profile' }
      } catch (error) {
        console.error('Auth callback error:', error)
        return { path: '/' }
      }
    }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach(async (to, from, next) => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (to.meta.requiresAuth && !session) {
    next('/')
  } else {
    next()
  }
})

export default router