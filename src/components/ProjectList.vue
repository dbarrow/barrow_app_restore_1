<script setup lang="ts">
import { onMounted, watch } from 'vue'
import { useProjectsStore } from '../stores/projects'
import type { Client } from '../types/database'

const props = defineProps<{
  selectedClient?: Client
}>()

const projectsStore = useProjectsStore()

onMounted(() => {
  if (props.selectedClient) {
    projectsStore.fetchProjects(props.selectedClient.id)
  }
})

watch(() => props.selectedClient, (client) => {
  if (client) {
    projectsStore.fetchProjects(client.id)
  }
})
</script>

<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-semibold">Projects</h2>
      <button 
        class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
        @click="$emit('new-project')"
      >
        Add Project
      </button>
    </div>

    <div v-if="!selectedClient" class="text-gray-600">
      Select a client to view their projects
    </div>
    
    <template v-else>
      <div v-if="projectsStore.loading" class="text-center py-4">
        Loading...
      </div>
      
      <div v-else-if="projectsStore.error" class="text-red-600 py-4">
        {{ projectsStore.error }}
      </div>
      
      <div v-else class="space-y-4">
        <div 
          v-for="project in projectsStore.projects" 
          :key="project.id"
          class="bg-white p-4 rounded-lg shadow-sm border border-gray-200"
        >
          <div class="flex justify-between items-start">
            <div>
              <h3 class="font-medium text-gray-900">{{ project.name }}</h3>
              <p class="text-sm text-gray-600">{{ project.description }}</p>
              <span 
                class="inline-block mt-2 px-2 py-1 text-xs rounded"
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
            <div class="flex gap-2">
              <button 
                class="text-sm px-3 py-1 text-gray-600 hover:text-indigo-600"
                @click="$emit('edit-project', project)"
              >
                Edit
              </button>
              <button 
                class="text-sm px-3 py-1 text-red-600 hover:text-red-700"
                @click="$emit('delete-project', project)"
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>