-- Add logging function to debug organization access
CREATE OR REPLACE FUNCTION debug_organization_access()
RETURNS trigger AS $$
BEGIN
  RAISE LOG 'Organization Access Debug:';
  RAISE LOG 'User domain: %', SPLIT_PART(auth.jwt()->>'email', '@', 2);
  RAISE LOG 'Record domain: %', NEW.organization_domain;
  IF TG_TABLE_NAME = 'projects' THEN
    RAISE LOG 'Client domain: %', (
      SELECT organization_domain 
      FROM clients 
      WHERE id = NEW.client_id
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add debug triggers
DROP TRIGGER IF EXISTS debug_projects_access ON projects;
CREATE TRIGGER debug_projects_access
  BEFORE INSERT OR UPDATE ON projects
  FOR EACH ROW
  EXECUTE FUNCTION debug_organization_access();

-- Reinforce project policies with explicit domain checks
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = projects.client_id
      AND clients.organization_domain = projects.organization_domain
      AND clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = projects.client_id
      AND clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = projects.client_id
      AND clients.organization_domain = projects.organization_domain
      AND clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = projects.client_id
      AND clients.organization_domain = projects.organization_domain
      AND clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );