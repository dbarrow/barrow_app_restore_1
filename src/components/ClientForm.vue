<script setup lang="ts">
import { ref } from 'vue'
import type { Client } from '../types/database'

const props = defineProps<{
  client?: Client
}>()

const emit = defineEmits<{
  (e: 'save', data: { name: string; email: string; phone: string | null }): void
  (e: 'cancel'): void
}>()

const name = ref(props.client?.name ?? '')
const email = ref(props.client?.email ?? '')
const phone = ref(props.client?.phone ?? '')

function handleSubmit() {
  emit('save', {
    name: name.value,
    email: email.value,
    phone: phone.value || null
  })
}
</script>

<template>
  <div class="p-6">
    <h2 class="text-xl font-semibold mb-6">
      {{ client ? 'Edit Client' : 'New Client' }}
    </h2>
    
    <form @submit.prevent="handleSubmit" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700">Name</label>
        <input
          v-model="name"
          type="text"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        />
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700">Email</label>
        <input
          v-model="email"
          type="email"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        />
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700">Phone</label>
        <input
          v-model="phone"
          type="tel"
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        />
      </div>
      
      <div class="flex justify-end gap-4">
        <button
          type="button"
          class="px-4 py-2 text-gray-700 hover:text-gray-900"
          @click="$emit('cancel')"
        >
          Cancel
        </button>
        <button
          type="submit"
          class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
        >
          Save
        </button>
      </div>
    </form>
  </div>
</template>