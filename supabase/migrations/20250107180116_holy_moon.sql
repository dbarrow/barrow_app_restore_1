/*
  # Add organization domain isolation
  
  1. Changes
    - Add organization_domain to clients and projects tables
    - Create function to extract domain from email
    - Add triggers to maintain organization_domain
    - Update RLS policies to scope by organization domain
*/

-- Add organization domain columns
ALTER TABLE clients ADD COLUMN organization_domain text;
ALTER TABLE projects ADD COLUMN organization_domain text;

-- Create function to extract domain
CREATE OR REPLACE FUNCTION get_email_domain()
RETURNS text
LANGUAGE SQL STABLE
AS $$
  SELECT SPLIT_PART(current_setting('request.jwt.claim.email', true), '@', 2);
$$;

-- Create trigger function
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  NEW.organization_domain = get_email_domain();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER set_client_organization_domain
  BEFORE INSERT OR UPDATE ON clients
  FOR EACH ROW
  EXECUTE FUNCTION set_organization_domain();

CREATE TRIGGER set_project_organization_domain
  BEFORE INSERT OR UPDATE ON projects
  FOR EACH ROW
  EXECUTE FUNCTION set_organization_domain();

-- Update RLS policies for clients
DROP POLICY IF EXISTS "Users can view their own clients" ON clients;
CREATE POLICY "Users can view clients from same organization"
  ON clients FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create their own clients" ON clients;
CREATE POLICY "Users can create clients in their organization"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

DROP POLICY IF EXISTS "Users can update their own clients" ON clients;
CREATE POLICY "Users can update clients in their organization"
  ON clients FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete their own clients" ON clients;
CREATE POLICY "Users can delete clients in their organization"
  ON clients FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Update RLS policies for projects
DROP POLICY IF EXISTS "Users can view their own projects" ON projects;
CREATE POLICY "Users can view projects from same organization"
  ON projects FOR SELECT TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can create their own projects" ON projects;
CREATE POLICY "Users can create projects in their organization"
  ON projects FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = created_by);

DROP POLICY IF EXISTS "Users can update their own projects" ON projects;
CREATE POLICY "Users can update projects in their organization"
  ON projects FOR UPDATE TO authenticated
  USING (organization_domain = get_email_domain());

DROP POLICY IF EXISTS "Users can delete their own projects" ON projects;
CREATE POLICY "Users can delete projects in their organization"
  ON projects FOR DELETE TO authenticated
  USING (organization_domain = get_email_domain());

-- Backfill existing records
UPDATE clients 
SET organization_domain = SPLIT_PART(
  (SELECT email FROM auth.users WHERE id = clients.created_by),
  '@',
  2
);

UPDATE projects 
SET organization_domain = SPLIT_PART(
  (SELECT email FROM auth.users WHERE id = projects.created_by),
  '@',
  2
);