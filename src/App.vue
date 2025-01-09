<script setup lang="ts">
import { onMounted } from 'vue'
import { useAuthStore } from './stores/auth'
import { supabase } from './lib/supabase'

const auth = useAuthStore()

onMounted(() => {
  supabase.auth.onAuthStateChange((event, session) => {
    auth.user = session?.user ?? null
  })
})
</script>

<template>
  <router-view />
</template>