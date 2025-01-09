-- Update client policies to allow insert without organization check
DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (true);

-- Update project policies similarly
DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (true);

-- The trigger will handle setting the correct organization_domain and created_by