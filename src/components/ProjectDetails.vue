<script setup lang="ts">
import { ref, onMounted } from 'vue'
import type { Project } from '../types/database'
import { useClientsStore } from '../stores/clients'

const props = defineProps<{
  project: Project
}>()

const clientsStore = useClientsStore()
const clientName = ref('')

onMounted(async () => {
  await clientsStore.fetchClients()
  const client = clientsStore.clients.find(c => c.id === props.project.client_id)
  clientName.value = client?.name ?? 'Unknown Client'
})
</script>

<template>
  <div class="h-full p-6 overflow-y-auto">
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <div class="flex justify-between items-start mb-6">
        <div>
          <h2 class="text-2xl font-semibold text-gray-900">{{ project.name }}</h2>
          <p class="text-sm text-gray-600 mt-1">Client: {{ clientName }}</p>
        </div>
        <span 
          class="px-3 py-1 text-sm rounded-full"
          :class="{
            'bg-green-100 text-green-800': project.status === 'active',
            'bg-gray-100 text-gray-800': project.status === 'completed',
            'bg-yellow-100 text-yellow-800': project.status === 'on-hold',
            'bg-red-100 text-red-800': project.status === 'cancelled'
          }"
        >
          {{ project.status }}
        </span>
      </div>

      <div class="prose max-w-none">
        <h3 class="text-lg font-medium text-gray-900 mb-2">Description</h3>
        <p class="text-gray-600">{{ project.description || 'No description provided.' }}</p>
      </div>

      <div class="mt-6 border-t border-gray-200 pt-6">
        <h3 class="text-lg font-medium text-gray-900 mb-2">Project Details</h3>
        <dl class="grid grid-cols-2 gap-4">
          <div>
            <dt class="text-sm font-medium text-gray-500">Created</dt>
            <dd class="text-sm text-gray-900">{{ new Date(project.created_at).toLocaleDateString() }}</dd>
          </div>
          <div>
            <dt class="text-sm font-medium text-gray-500">Last Updated</dt>
            <dd class="text-sm text-gray-900">{{ new Date(project.updated_at).toLocaleDateString() }}</dd>
          </div>
        </dl>
      </div>
    </div>
  </div>
</template>