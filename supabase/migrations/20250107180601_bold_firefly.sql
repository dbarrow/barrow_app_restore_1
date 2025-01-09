/*
  # Fix RLS policies for organization-based access

  1. Changes
    - Modify client and project creation policies to allow initial insert
    - Add organization domain check to trigger instead
  
  2. Security
    - Maintains organization isolation
    - Ensures domain is set correctly via trigger
*/

-- Update trigger function to enforce organization domain
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  -- Set organization domain
  NEW.organization_domain = get_email_domain();
  
  -- Verify organization domain matches for updates
  IF TG_OP = 'UPDATE' AND NEW.organization_domain != get_email_domain() THEN
    RAISE EXCEPTION 'Cannot change organization domain';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update client creation policy
DROP POLICY IF EXISTS "Users can create clients in their organization" ON clients;
CREATE POLICY "Users can create clients in their organization"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Update project creation policy
DROP POLICY IF EXISTS "Users can create projects in their organization" ON projects;
CREATE POLICY "Users can create projects in their organization"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);