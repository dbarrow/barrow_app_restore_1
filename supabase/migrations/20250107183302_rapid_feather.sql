-- Update client creation policy to be more permissive
DROP POLICY IF EXISTS "Users can create organization clients" ON clients;
CREATE POLICY "Users can create organization clients"
  ON clients FOR INSERT TO authenticated
  WITH CHECK (true);

-- Other policies remain unchanged as they handle organization boundaries