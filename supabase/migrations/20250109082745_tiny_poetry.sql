/*
  # Fix project organization isolation

  1. Changes
    - Update project policies to properly enforce organization boundaries
    - Ensure projects can only be accessed by users from the same organization
    - Mirror the successful client isolation pattern

  2. Security
    - Enforce organization-level isolation for all CRUD operations
    - Validate organization domain matches user's domain
*/

-- Update project policies to properly enforce organization boundaries
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
CREATE POLICY "Users can view organization projects"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2));

DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
CREATE POLICY "Users can create organization projects"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2));

DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
CREATE POLICY "Users can update organization projects"
  ON projects FOR UPDATE TO authenticated
  USING (organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2));

DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
CREATE POLICY "Users can delete organization projects"
  ON projects FOR DELETE TO authenticated
  USING (organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2));

-- Update trigger to ensure organization domain consistency
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
DECLARE
  user_domain text;
  client_domain text;
BEGIN
  -- Get user's domain
  user_domain := SPLIT_PART(auth.jwt()->>'email', '@', 2);
  
  -- Set organization domain if not provided
  IF NEW.organization_domain IS NULL THEN
    NEW.organization_domain := user_domain;
  END IF;

  -- Validate organization domain matches user's domain
  IF NEW.organization_domain != user_domain THEN
    RAISE EXCEPTION 'Organization domain must match user''s email domain';
  END IF;

  -- For projects, verify client belongs to same organization
  IF TG_TABLE_NAME = 'projects' THEN
    SELECT organization_domain INTO client_domain
    FROM clients
    WHERE id = NEW.client_id;

    IF client_domain != user_domain THEN
      RAISE EXCEPTION 'Client must belong to the same organization';
    END IF;
  END IF;

  -- Set created_by
  NEW.created_by := auth.uid();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;