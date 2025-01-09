/*
  # Simplify RLS policies

  1. Changes
    - Remove organization domain checks
    - Allow authenticated users basic access
    - Keep user ownership requirement for creation
*/

-- Update client policies
DROP POLICY IF EXISTS "Users can view clients from same organization" ON clients;
CREATE POLICY "Users can view all clients"
  ON clients FOR SELECT TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can create clients in their organization" ON clients;
CREATE POLICY "Users can create own clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

DROP POLICY IF EXISTS "Users can update clients in their organization" ON clients;
CREATE POLICY "Users can update all clients"
  ON clients FOR UPDATE TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can delete clients in their organization" ON clients;
CREATE POLICY "Users can delete all clients"
  ON clients FOR DELETE TO authenticated
  USING (true);

-- Update project policies
DROP POLICY IF EXISTS "Users can view projects from same organization" ON projects;
CREATE POLICY "Users can view all projects"
  ON projects FOR SELECT TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can create projects in their organization" ON projects;
CREATE POLICY "Users can create own projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

DROP POLICY IF EXISTS "Users can update projects in their organization" ON projects;
CREATE POLICY "Users can update all projects"
  ON projects FOR UPDATE TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can delete projects in their organization" ON projects;
CREATE POLICY "Users can delete all projects"
  ON projects FOR DELETE TO authenticated
  USING (true);