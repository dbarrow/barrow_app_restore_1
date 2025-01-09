/*
  # Fix RLS policies for clients and projects

  1. Changes
    - Simplify client creation policy
    - Update organization domain handling
    - Fix project creation policy
    
  2. Security
    - Maintain organization-based access control
    - Ensure proper user authentication checks
*/

-- Simplify client creation policy
DROP POLICY IF EXISTS "Users can create clients in their organization" ON clients;
CREATE POLICY "Users can create clients in their organization"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Update organization domain trigger
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  NEW.organization_domain = get_email_domain();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update project creation policy
DROP POLICY IF EXISTS "Users can create projects in their organization" ON projects;
CREATE POLICY "Users can create projects in their organization"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Ensure other policies use organization domain for access control
DROP POLICY IF EXISTS "Users can view clients from same organization" ON clients;
CREATE POLICY "Users can view clients from same organization"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can view projects from same organization" ON projects;
CREATE POLICY "Users can view projects from same organization"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());