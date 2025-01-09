/*
  # Fix RLS policies for organization isolation
  
  1. Changes
    - Simplify client and project creation policies
    - Ensure organization domain is set via trigger
    - Maintain organization isolation for all operations
*/

-- Update client policies to properly handle organization isolation
DROP POLICY IF EXISTS "Users can view organization clients" ON clients;
CREATE POLICY "Users can view organization clients"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update organization clients" ON clients;
CREATE POLICY "Users can update organization clients"
  ON clients FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete organization clients" ON clients;
CREATE POLICY "Users can delete organization clients"
  ON clients FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Update project policies similarly
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Ensure trigger properly sets organization domain
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  NEW.organization_domain = get_email_domain();
  NEW.created_by = auth.uid();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;