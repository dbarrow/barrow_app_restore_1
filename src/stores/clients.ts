import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '../lib/supabase'
import type { Client } from '../types/database'
import { useAuthStore } from './auth'

export const useClientsStore = defineStore('clients', () => {
  const clients = ref<Client[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  const auth = useAuthStore()

  async function fetchClients() {
    try {
      loading.value = true
      error.value = null
      
      const { data, error: err } = await supabase
        .from('clients')
        .select('*')
        .order('name')
      
      if (err) throw err
      clients.value = data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch clients'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function createClient(client: Omit<Client, 'id' | 'created_at' | 'created_by' | 'organization_domain'>) {
    try {
      loading.value = true
      error.value = null
      
      const { data, error: err } = await supabase
        .from('clients')
        .insert([client])
        .select()
        .single()
      
      if (err) throw err
      if (data) {
        clients.value.push(data)
      }
      return data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to create client'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function updateClient(id: string, updates: Partial<Omit<Client, 'id' | 'created_at' | 'created_by' | 'organization_domain'>>) {
    try {
      loading.value = true
      error.value = null
      
      const { data, error: err } = await supabase
        .from('clients')
        .update(updates)
        .eq('id', id)
        .select()
        .single()
      
      if (err) throw err
      if (data) {
        const index = clients.value.findIndex(c => c.id === id)
        if (index !== -1) {
          clients.value[index] = data
        }
      }
      return data
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to update client'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function deleteClient(id: string) {
    try {
      loading.value = true
      error.value = null
      
      const { error: err } = await supabase
        .from('clients')
        .delete()
        .eq('id', id)
      
      if (err) throw err
      clients.value = clients.value.filter(c => c.id !== id)
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to delete client'
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    clients,
    loading,
    error,
    fetchClients,
    createClient,
    updateClient,
    deleteClient
  }
})