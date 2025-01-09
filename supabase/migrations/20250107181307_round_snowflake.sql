/*
  # Fix organization isolation

  1. Changes
    - Update RLS policies to properly isolate data by organization domain
    - Ensure users can only view/modify data from their own organization

  2. Security
    - Enforce organization domain checks in all policies
    - Maintain created_by check for inserts
*/

-- Update client policies
DROP POLICY IF EXISTS "Users can view all clients" ON clients;
CREATE POLICY "Users can view organization clients"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create own clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (
    auth.uid() = created_by AND
    organization_domain = get_email_domain()
  );

DROP POLICY IF EXISTS "Users can update all clients" ON clients;
CREATE POLICY "Users can update organization clients"
  ON clients FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete all clients" ON clients;
CREATE POLICY "Users can delete organization clients"
  ON clients FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Update project policies
DROP POLICY IF EXISTS "Users can view all projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create own projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (
    auth.uid() = created_by AND
    organization_domain = get_email_domain()
  );

DROP POLICY IF EXISTS "Users can update all projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete all projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());