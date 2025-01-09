<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useClientsStore } from '../stores/clients'
import { useProjectsStore } from '../stores/projects'
import type { Client, Project } from '../types/database'
import ClientList from '../components/ClientList.vue'
import ClientForm from '../components/ClientForm.vue'
import ProjectList from '../components/ProjectList.vue'
import ProjectForm from '../components/ProjectForm.vue'
import BaseMasterDetail from '../components/BaseMasterDetail.vue'
import ProjectDetails from '../components/ProjectDetails.vue'

const auth = useAuthStore()
const clientsStore = useClientsStore()
const projectsStore = useProjectsStore()

const activeView = ref<'clients' | 'projects'>('clients')
const selectedClient = ref<Client | undefined>()
const selectedProject = ref<Project | undefined>()
const editingClient = ref<Client | undefined>()
const showingClientForm = ref(false)
const editingProject = ref<Project | undefined>()
const showingProjectForm = ref(false)

// Search and filter
const searchQuery = ref('')
const statusFilter = ref<Project['status'] | 'all'>('all')

const filteredProjects = computed(() => {
  return projectsStore.projects.filter(project => {
    const matchesSearch = project.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      project.description?.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesStatus = statusFilter.value === 'all' || project.status === statusFilter.value
    return matchesSearch && matchesStatus
  })
})

// Reset state when switching views
watch(activeView, (newView) => {
  selectedClient.value = undefined
  selectedProject.value = undefined
  editingClient.value = undefined
  showingClientForm.value = false
  editingProject.value = undefined
  showingProjectForm.value = false
  
  if (newView === 'projects') {
    projectsStore.fetchProjects()
    clientsStore.fetchClients()
  }
})

// Client handlers
async function handleSaveClient(data: { name: string; email: string; phone: string | null }) {
  try {
    if (editingClient.value) {
      await clientsStore.updateClient(editingClient.value.id, data)
    } else {
      await clientsStore.createClient(data)
    }
    showingClientForm.value = false
    editingClient.value = undefined
  } catch (error) {
    console.error('Failed to save client:', error)
  }
}

async function handleDeleteClient(client: Client) {
  if (confirm(`Are you sure you want to delete ${client.name}?`)) {
    try {
      await clientsStore.deleteClient(client.id)
      if (selectedClient.value?.id === client.id) {
        selectedClient.value = undefined
      }
    } catch (error) {
      console.error('Failed to delete client:', error)
    }
  }
}

// Project handlers
async function handleSaveProject(data: { name: string; description: string | null; status: Project['status']; client_id: string }) {
  try {
    if (editingProject.value) {
      await projectsStore.updateProject(editingProject.value.id, data)
    } else {
      await projectsStore.createProject(data)
    }
    showingProjectForm.value = false
    editingProject.value = undefined
  } catch (error) {
    console.error('Failed to save project:', error)
  }
}

async function handleDeleteProject(project: Project) {
  if (confirm(`Are you sure you want to delete ${project.name}?`)) {
    try {
      await projectsStore.deleteProject(project.id)
      if (selectedProject.value?.id === project.id) {
        selectedProject.value = undefined
      }
    } catch (error) {
      console.error('Failed to delete project:', error)
    }
  }
}

function handleProjectClick(project: Project) {
  selectedProject.value = project
}
</script>

<template>
  <div class="h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white shadow-sm border-b border-gray-200 flex-shrink-0">
      <div class="px-4 py-3">
        <div class="flex justify-between items-center mb-2">
          <h1 class="text-xl font-semibold text-gray-900">Dashboard</h1>
          <div class="flex items-center gap-4">
            <span class="text-sm text-gray-600">{{ auth.user?.email }}</span>
            <button
              @click="auth.signOut"
              class="px-3 py-1.5 text-sm bg-red-600 text-white rounded hover:bg-red-700"
            >
              Sign Out
            </button>
          </div>
        </div>
        
        <!-- Navigation Menu -->
        <nav class="flex gap-4">
          <button
            @click="activeView = 'clients'"
            class="px-3 py-2 text-sm font-medium rounded-md"
            :class="activeView === 'clients' 
              ? 'bg-indigo-100 text-indigo-700' 
              : 'text-gray-600 hover:text-gray-900'"
          >
            Clients
          </button>
          <button
            @click="activeView = 'projects'"
            class="px-3 py-2 text-sm font-medium rounded-md"
            :class="activeView === 'projects' 
              ? 'bg-indigo-100 text-indigo-700' 
              : 'text-gray-600 hover:text-gray-900'"
          >
            Projects
          </button>
        </nav>
      </div>
    </header>

    <!-- Main content area -->
    <BaseMasterDetail>
      <!-- Master Section -->
      <template #master>
        <template v-if="activeView === 'clients'">
          <template v-if="showingClientForm">
            <ClientForm
              :client="editingClient"
              @save="handleSaveClient"
              @cancel="showingClientForm = false; editingClient = undefined"
            />
          </template>
          <template v-else>
            <ClientList
              @new-client="showingClientForm = true"
              @select-client="selectedClient = $event"
              @edit-client="editingClient = $event; showingClientForm = true"
              @delete-client="handleDeleteClient"
            />
          </template>
        </template>
        <template v-else>
          <!-- Projects View -->
          <div class="p-6">
            <div class="flex justify-between items-center mb-6">
              <h2 class="text-xl font-semibold">Projects</h2>
              <button 
                class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
                @click="showingProjectForm = true"
              >
                Add Project
              </button>
            </div>
            <div class="space-y-4">
              <!-- Search and Filters -->
              <div class="space-y-3">
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="Search projects..."
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
                <select
                  v-model="statusFilter"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                >
                  <option value="all">All Status</option>
                  <option value="active">Active</option>
                  <option value="completed">Completed</option>
                  <option value="on-hold">On Hold</option>
                  <option value="cancelled">Cancelled</option>
                </select>
              </div>
              
              <!-- Projects List -->
              <div class="space-y-3">
                <div
                  v-for="project in filteredProjects"
                  :key="project.id"
                  class="bg-white p-4 rounded-lg shadow-sm border border-gray-200 hover:border-indigo-500 cursor-pointer"
                  @click="handleProjectClick(project)"
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
                        @click.stop="editingProject = project; showingProjectForm = true"
                      >
                        Edit
                      </button>
                      <button 
                        class="text-sm px-3 py-1 text-red-600 hover:text-red-700"
                        @click.stop="handleDeleteProject(project)"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </template>
      </template>

      <!-- Detail Section -->
      <template #detail>
        <template v-if="showingProjectForm">
          <ProjectForm
            :project="editingProject"
            :client="selectedClient"
            @save="handleSaveProject"
            @cancel="showingProjectForm = false; editingProject = undefined"
          />
        </template>
        <template v-else-if="activeView === 'clients' && selectedClient">
          <ProjectList
            :selected-client="selectedClient"
            @new-project="showingProjectForm = true"
            @edit-project="editingProject = $event; showingProjectForm = true"
            @delete-project="handleDeleteProject"
          />
        </template>
        <template v-else-if="activeView === 'projects' && selectedProject">
          <ProjectDetails :project="selectedProject" />
        </template>
      </template>
    </BaseMasterDetail>
  </div>
</template>