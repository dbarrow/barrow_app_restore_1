/*
  # Fix RLS policies for organization isolation

  1. Changes
    - Update client creation policy to check organization domain
    - Update project creation policy to check organization domain
    - Ensure proper organization isolation for all operations
*/

-- Update client creation policy to check organization domain
DROP POLICY IF EXISTS "Users can create clients in their organization" ON clients;
CREATE POLICY "Users can create clients in their organization"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (
    auth.uid() = created_by AND
    organization_domain = get_email_domain()
  );

-- Update project creation policy to check organization domain
DROP POLICY IF EXISTS "Users can create projects in their organization" ON projects;
CREATE POLICY "Users can create projects in their organization"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (
    auth.uid() = created_by AND
    organization_domain = get_email_domain()
  );