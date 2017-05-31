class Logger
  def self.log(message)
    puts "[PedMatch_BDD_INFO]: #{message}"
  end
  def self.error(message)
    puts "[PedMatch_BDD_ERROR]: #{message}"
  end
  def self.warning(message)
    puts "[PedMatch_BDD_WARNING]: #{message}"
  end
end