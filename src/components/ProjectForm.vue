<script setup lang="ts">
import { ref } from 'vue'
import type { Project, Client } from '../types/database'
import { useClientsStore } from '../stores/clients'

const props = defineProps<{
  project?: Project
  client?: Client
}>()

const emit = defineEmits<{
  (e: 'save', data: { name: string; description: string | null; status: Project['status']; client_id: string }): void
  (e: 'cancel'): void
}>()

const clientsStore = useClientsStore()
const name = ref(props.project?.name ?? '')
const description = ref(props.project?.description ?? '')
const status = ref<Project['status']>(props.project?.status ?? 'active')
const selectedClientId = ref(props.project?.client_id ?? props.client?.id ?? '')

const statusOptions: Project['status'][] = ['active', 'completed', 'on-hold', 'cancelled']

function handleSubmit() {
  emit('save', {
    name: name.value,
    description: description.value || null,
    status: status.value,
    client_id: selectedClientId.value
  })
}
</script>

<template>
  <div class="p-6">
    <h2 class="text-xl font-semibold mb-6">
      {{ project ? 'Edit Project' : 'New Project' }}
    </h2>
    
    <form @submit.prevent="handleSubmit" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Client</label>
        <select
          v-model="selectedClientId"
          required
          class="mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        >
          <option value="" disabled>Select a client</option>
          <option 
            v-for="client in clientsStore.clients" 
            :key="client.id" 
            :value="client.id"
          >
            {{ client.name }}
          </option>
        </select>
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
        <input
          v-model="name"
          type="text"
          required
          class="mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        />
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
        <textarea
          v-model="description"
          rows="3"
          class="mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        ></textarea>
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
        <select
          v-model="status"
          class="mt-1 block w-full px-3 py-2 rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        >
          <option v-for="option in statusOptions" :key="option" :value="option">
            {{ option }}
          </option>
        </select>
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