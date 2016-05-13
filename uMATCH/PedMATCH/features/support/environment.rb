module Environment
  @tier = "server"

  def self.getTier
    return @tier
  end

  def self.setTier tier
    if tier == "local"
      require_relative './env_local.rb'
    elsif tier == "server"
      require_relative './env.rb'
    end
    @tier = tier
    if(tier)
      puts "environment set to tier [" + tier.to_s + "]"
    end
  end
end