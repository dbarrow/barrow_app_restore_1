-- Update client policies to ensure proper access control
DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (true);

-- Ensure trigger function handles all required fields
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  -- Set organization domain and created_by
  NEW.organization_domain = get_email_domain();
  NEW.created_by = auth.uid();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;