import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '../lib/supabase'
import type { Project } from '../types/database'
import { useAuthStore } from './auth'

export const useProjectsStore = defineStore('projects', () => {
  const projects = ref<Project[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const auth = useAuthStore()

  async function fetchProjects(clientId?: string) {
    try {
      loading.value = true
      error.value = null
      
      let query = supabase
        .from('projects')
        .select('*')
        .order('created_at', { ascending: false })

      if (clientId) {
        query = query.eq('client_id', clientId)
      }
      
      const { data, error: err } = await query
      
      if (err) throw err
      projects.value = data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch projects'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function createProject(project: Omit<Project, 'id' | 'created_at' | 'updated_at' | 'created_by'>) {
    if (!auth.user?.id) throw new Error('User not authenticated')

    try {
      loading.value = true
      error.value = null
      
      const { data, error: err } = await supabase
        .from('projects')
        .insert([{ ...project, created_by: auth.user.id }])
        .select()
        .single()
      
      if (err) throw err
      if (data) {
        projects.value.unshift(data)
      }
      return data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to create project'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function updateProject(id: string, updates: Partial<Omit<Project, 'id' | 'created_at' | 'updated_at' | 'created_by'>>) {
    try {
      loading.value = true
      error.value = null
      
      const { data, error: err } = await supabase
        .from('projects')
        .update(updates)
        .eq('id', id)
        .select()
        .single()
      
      if (err) throw err
      if (data) {
        const index = projects.value.findIndex(p => p.id === id)
        if (index !== -1) {
          projects.value[index] = data
        }
      }
      return data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to update project'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function deleteProject(id: string) {
    try {
      loading.value = true
      error.value = null
      
      const { error: err } = await supabase
        .from('projects')
        .delete()
        .eq('id', id)
      
      if (err) throw err
      projects.value = projects.value.filter(p => p.id !== id)
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to delete project'
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    projects,
    loading,
    error,
    fetchProjects,
    createProject,
    updateProject,
    deleteProject
  }
})