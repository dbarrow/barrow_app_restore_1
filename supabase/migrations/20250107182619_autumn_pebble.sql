-- Update trigger function to set both organization_domain and created_by
CREATE OR REPLACE FUNCTION set_organization_domain()
RETURNS TRIGGER AS $$
BEGIN
  -- Set organization domain from user's email
  NEW.organization_domain = get_email_domain();
  
  -- Set created_by from current user
  NEW.created_by = auth.uid();
  
  -- For projects, verify client belongs to same organization
  IF TG_TABLE_NAME = 'projects' THEN
    IF NOT EXISTS (
      SELECT 1 FROM clients 
      WHERE id = NEW.client_id 
      AND organization_domain = NEW.organization_domain
    ) THEN
      RAISE EXCEPTION 'Client must belong to the same organization';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;