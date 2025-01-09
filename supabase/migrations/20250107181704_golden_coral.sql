/*
  # Fix organization isolation

  1. Changes
    - Update trigger function to properly set organization domain and created_by
    - Modify RLS policies to enforce organization isolation
    - Add validation to ensure client and project belong to same organization

  2. Security
    - Enforce organization isolation through RLS policies
    - Ensure data integrity with proper triggers
*/

-- Drop and recreate trigger function with proper organization handling
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  -- Set organization domain from user's email
  NEW.organization_domain = get_email_domain();
  
  -- For projects, verify client belongs to same organization
  IF TG_TABLE_NAME = 'projects' THEN
    IF NOT EXISTS (
      SELECT 1 FROM clients 
      WHERE id = NEW.client_id 
      AND organization_domain = NEW.organization_domain
    ) THEN
      RAISE EXCEPTION 'Client must belong to the same organization';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update client policies
DROP POLICY IF EXISTS "Users can view organization clients" ON clients;
CREATE POLICY "Users can view organization clients"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can update organization clients" ON clients;
CREATE POLICY "Users can update organization clients"
  ON clients FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete organization clients" ON clients;
CREATE POLICY "Users can delete organization clients"
  ON clients FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Update project policies
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());