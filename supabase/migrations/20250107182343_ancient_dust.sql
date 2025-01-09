/*
  # Organization Isolation

  1. Changes
    - Update RLS policies to restrict access by organization domain
    - Ensure clients and projects are only visible within their organization
    - Enforce organization boundaries for all CRUD operations

  2. Security
    - Enable strict organization-based access control
    - Prevent cross-organization data access
*/

-- Update client policies for organization isolation
DROP POLICY IF EXISTS "Users can view clients" ON clients;
CREATE POLICY "Users can view organization clients"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can update clients" ON clients;
CREATE POLICY "Users can update organization clients"
  ON clients FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete clients" ON clients;
CREATE POLICY "Users can delete organization clients"
  ON clients FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Update project policies for organization isolation
DROP POLICY IF EXISTS "Users can view projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can update projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Ensure trigger properly enforces organization boundaries
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