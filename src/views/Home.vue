<script setup lang="ts">
import { useAuthStore } from '../stores/auth'
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const auth = useAuthStore()
const error = ref('')

// Redirect to profile if already logged in
watch(() => auth.user, (newUser) => {
  if (newUser) {
    router.push('/profile')
  }
})

async function handleGoogleSignIn() {
  try {
    error.value = ''
    await auth.signInWithGoogle()
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Authentication failed'
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow">
      <div class="text-center">
        <h2 class="text-3xl font-extrabold text-gray-900">Welcome</h2>
        <p class="mt-2 text-gray-600">Sign in to get started</p>
      </div>
      <div class="mt-8">
        <button
          @click="handleGoogleSignIn"
          :disabled="auth.loading"
          class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          {{ auth.loading ? 'Loading...' : 'Sign in with Google' }}
        </button>
        <p v-if="error" class="mt-2 text-sm text-red-600">
          {{ error }}
        </p>
      </div>
    </div>
  </div>
</template>