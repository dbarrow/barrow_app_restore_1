-- Relax client policies to allow basic operations
DROP POLICY IF EXISTS "Users can view organization clients" ON clients;
CREATE POLICY "Users can view clients"
  ON clients FOR SELECT TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update organization clients" ON clients;
CREATE POLICY "Users can update clients"
  ON clients FOR UPDATE TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can delete organization clients" ON clients;
CREATE POLICY "Users can delete clients"
  ON clients FOR DELETE TO authenticated
  USING (true);

-- Relax project policies similarly
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view projects"
  ON projects FOR SELECT TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
CREATE POLICY "Users can create projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
CREATE POLICY "Users can update projects"
  ON projects FOR UPDATE TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
CREATE POLICY "Users can delete projects"
  ON projects FOR DELETE TO authenticated
  USING (true);