class Logger
  @hide_log = false
  def self.hide_log(hide=true)
    @hide_log = hide
  end
  def self.info(message)
    puts "[PedMatch_BDD_INFO]: #{message}" unless @hide_log
  end
  def self.error(message)
    puts "[PedMatch_BDD_ERROR]: #{message}"
  end
  def self.warning(message)
    puts "[PedMatch_BDD_WARNING]: #{message}"
  end
end