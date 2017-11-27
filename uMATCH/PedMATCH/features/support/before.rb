Before do
  if ENV['TRAVIS']
    Environment.setTier 'int' #NEVER change this line!!!!
  else
    Environment.setTier 'local' #set this value to 'int' if you want to connect to int from your local
  end
end
