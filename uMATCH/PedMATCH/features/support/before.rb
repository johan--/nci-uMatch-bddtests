Before do
  if ENV['TRAVIS']
    Environment.setTier 'server' #NEVER change this line!!!!
  else
    Environment.setTier 'local' #set this value to 'server' if you want to connect to int from your local
  end
end
