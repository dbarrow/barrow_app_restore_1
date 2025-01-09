export interface Client {
  id: string
  name: string
  email: string
  phone: string | null
  created_at: string
  created_by: string
}

export interface Project {
  id: string
  name: string
  description: string | null
  status: 'active' | 'completed' | 'on-hold' | 'cancelled'
  client_id: string
  created_at: string
  updated_at: string
  created_by: string
}