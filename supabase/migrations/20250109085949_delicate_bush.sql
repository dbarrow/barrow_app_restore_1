/*
  # Fix Project Policies

  1. Changes
    - Remove duplicate policies
    - Enforce strict organization boundaries
    - Simplify policy conditions for better performance
    - Add better error messages to trigger function

  2. Security
    - Ensure projects can only be accessed by users from the same organization
    - Verify client and project organization domains match
    - Prevent cross-organization access
*/

-- Drop all existing project policies
DROP POLICY IF EXISTS "enforce_project_org_delete" ON projects;
DROP POLICY IF EXISTS "enforce_project_org_insert" ON projects;
DROP POLICY IF EXISTS "enforce_project_org_select" ON projects;
DROP POLICY IF EXISTS "enforce_project_org_update" ON projects;
DROP POLICY IF EXISTS "Users can create organization projects" ON projects;
DROP POLICY IF EXISTS "Users can create projects" ON projects;
DROP POLICY IF EXISTS "Users can delete organization projects" ON projects;
DROP POLICY IF EXISTS "Users can delete projects" ON projects;
DROP POLICY IF EXISTS "Users can update organization projects" ON projects;
DROP POLICY IF EXISTS "Users can update projects" ON projects;
DROP POLICY IF EXISTS "Users can view organization projects" ON projects;
DROP POLICY IF EXISTS "Users can view projects" ON projects;

-- Create new simplified policies
CREATE POLICY "project_select_policy"
  ON projects FOR SELECT TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

CREATE POLICY "project_insert_policy"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

CREATE POLICY "project_update_policy"
  ON projects FOR UPDATE TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

CREATE POLICY "project_delete_policy"
  ON projects FOR DELETE TO authenticated
  USING (
    organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    AND client_id IN (
      SELECT id FROM clients
      WHERE clients.organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2)
    )
  );

-- Update trigger function with better error handling
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
      RAISE EXCEPTION 'Client with ID % not found', NEW.client_id;
    END IF;

    IF client_domain != user_domain THEN
      RAISE EXCEPTION 'Access denied: Client belongs to organization % but you are from organization %', 
        client_domain, user_domain;
    END IF;
  END IF;

  -- Set created_by
  NEW.created_by := auth.uid();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;