/*
  # Strengthen organization boundaries

  1. Changes
    - Update project policies to strictly enforce organization domain boundaries
    - Add additional checks in trigger function for organization consistency
    - Ensure projects can only be accessed by users from the same organization

  2. Security
    - Enforce organization isolation at both policy and trigger levels
    - Validate client and project organization domains match user's domain
*/

-- Update project policies to strictly enforce organization boundaries
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = projects.client_id
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
      AND clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

-- Update trigger to ensure strict organization domain consistency
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

    IF client_domain IS NULL OR client_domain != user_domain THEN
      RAISE EXCEPTION 'Client must belong to the same organization';
    END IF;
  END IF;

  -- Set created_by
  NEW.created_by := auth.uid();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;