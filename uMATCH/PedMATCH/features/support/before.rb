Before do
  Environment.setTier 'server' #set this value to 'local' if you are running tests on your local machine.
  Auth0Token.generate_auth0_token('ADMIN')
end
