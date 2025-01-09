/*
  # Update organization domain handling

  1. Changes
    - Update policies to use explicit organization domain check
    - Modify trigger to preserve provided organization domain
    - Add validation for organization domain match
*/

-- Update client policies to use explicit organization domain
DROP POLICY IF EXISTS "Users can view organization clients" ON clients;
CREATE POLICY "Users can view organization clients"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2));

DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (organization_domain = SPLIT_PART(auth.jwt()->>'email', '@', 2));

-- Update trigger to validate organization domain
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
DECLARE
  user_domain text;
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

  -- Set created_by
  NEW.created_by := auth.uid();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;