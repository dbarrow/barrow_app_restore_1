-- Strengthen organization boundaries with additional checks

-- Update project policies with stricter organization checks
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (
    projects.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND projects.client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (
    projects.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND projects.client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (
    projects.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND projects.client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

-- Add additional validation to the trigger function
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
DECLARE
  user_domain text;
  client_domain text;
BEGIN
  -- Get user's domain
  user_domain := SPLIT_PART(auth.jwt()->>'email', '@', 2);
  
  -- Set organization domain from user's domain
  NEW.organization_domain := user_domain;
  
  -- For projects, verify client belongs to same organization
  IF TG_TABLE_NAME = 'projects' THEN
    SELECT organization_domain INTO client_domain
    FROM clients
    WHERE id = NEW.client_id;

    IF client_domain IS NULL THEN
      RAISE EXCEPTION 'Client not found';
    END IF;

    IF client_domain != user_domain THEN
      RAISE EXCEPTION 'Client must belong to the same organization (client domain: %, user domain: %)', client_domain, user_domain;
    END IF;
  END IF;

  -- Set created_by
  NEW.created_by := auth.uid();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;