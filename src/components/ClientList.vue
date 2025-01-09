<script setup lang="ts">
import { onMounted } from 'vue'
import { useClientsStore } from '../stores/clients'

const clientsStore = useClientsStore()

onMounted(() => {
  clientsStore.fetchClients()
})
</script>

<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-semibold">Clients</h2>
      <button 
        class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
        @click="$emit('new-client')"
      >
        Add Client
      </button>
    </div>

    <div v-if="clientsStore.loading" class="text-center py-4">
      Loading...
    </div>
    
    <div v-else-if="clientsStore.error" class="text-red-600 py-4">
      {{ clientsStore.error }}
    </div>
    
    <div v-else class="space-y-4">
      <div 
        v-for="client in clientsStore.clients" 
        :key="client.id"
        class="bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-indigo-500 cursor-pointer"
        @click="$emit('select-client', client)"
      >
        <div class="flex justify-between items-start">
          <div>
            <h3 class="font-medium text-gray-900">{{ client.name }}</h3>
            <p class="text-sm text-gray-600">{{ client.email }}</p>
            <p v-if="client.phone" class="text-sm text-gray-600">{{ client.phone }}</p>
          </div>
          <div class="flex gap-2">
            <button 
              class="text-sm px-3 py-1 text-gray-600 hover:text-indigo-600"
              @click.stop="$emit('edit-client', client)"
            >
              Edit
            </button>
            <button 
              class="text-sm px-3 py-1 text-red-600 hover:text-red-700"
              @click.stop="$emit('delete-client', client)"
            >
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>