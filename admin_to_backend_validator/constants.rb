require_relative 'logger'
class Constants
  TIERS = %w(local int uat prod)
  @tier = TIERS[0]

  def self.tier_local
    TIERS[0]
  end

  def self.tier_int
    TIERS[1]
  end

  def self.tier_uat
    TIERS[2]
  end

  def self.tier_prod
    TIERS[3]
  end

  def self.current_tier
    @tier
  end

  def self.set_tier(tier)
    if TIERS.include?(tier)
      @tier = tier
      Logger.info("Constants tier has been set to #{@tier}")
    else
      Logger.error("Tier value can only be #{TIERS.to_s}, the passed in value is #{tier}")
    end
  end

  def self.url_ta_api
    case @tier
      when TIERS[0] then
        'http://localhost:10235/api/v1/treatment_arms'
      when TIERS[1] then
        'https://pedmatch-int.nci.nih.gov/api/v1/treatment_arms'
      when TIERS[2] then
        'https://pedmatch-uat.nci.nih.gov/api/v1/treatment_arms'
      when TIERS[3] then
        'https://pedmatch.nci.nih.gov/api/v1/treatment_arms'
      else
        'http://localhost:10235/api/v1/treatment_arms'
    end
  end

  def self.url_patient_api
    case @tier
      when TIERS[0] then
        'http://localhost:10240/api/v1/patients'
      when TIERS[1] then
        'https://pedmatch-int.nci.nih.gov/api/v1/patients'
      when TIERS[2] then
        'https://pedmatch-uat.nci.nih.gov/api/v1/patients'
      when TIERS[3] then
        'https://pedmatch.nci.nih.gov/api/v1/patients'
      else
        'http://localhost:10240/api/v1/patients'
    end
  end

  def self.url_ir_api
    case @tier
      when TIERS[0] then
        'http://localhost:5000/api/v1'
      when TIERS[1] then
        'https://pedmatch-int.nci.nih.gov/api/v1'
      when TIERS[2] then
        'https://pedmatch-uat.nci.nih.gov/api/v1'
      when TIERS[3] then
        'https://pedmatch.nci.nih.gov/api/v1'
      else
        'http://localhost:5000/api/v1'
    end
  end

  def self.s3_bucket
    case @tier
      when TIERS[0] then
        'pedmatch-dev'
      when TIERS[1] then
        'pedmatch-int'
      when TIERS[2] then
        'pedmatch-uat'
      when TIERS[2] then
        'pedmatch-prod'
      else
        'pedmatch-dev'
    end
  end

  def self.s3_bdd_ir
    'bdd_test_ion_reporter'
  end

  def self.dynamodb_url
    case @tier
      when TIERS[0] then
        'http://localhost:8000'
      when TIERS[1] then
        'https://dynamodb.us-east-1.amazonaws.com'
      when TIERS[2] then
        'https://dynamodb.us-east-1.amazonaws.com'
      else
        'http://localhost:8000'
    end
  end

  def self.dynamodb_region
    'us-east-1'
  end

  def self.auth0_client_id
    case @tier
      when TIERS[0] then
        ENV['AUTH0_CLIENT_ID']
      when TIERS[1] then
        ENV['INT_AUTH0_CLIENT_ID']
      when TIERS[2] then
        ENV['UAT_AUTH0_CLIENT_ID']
      when TIERS[3] then
        ENV['PROD_AUTH0_CLIENT_ID']
      else
        ENV['AUTH0_CLIENT_ID']
    end
  end

  def self.auth0_username
    case @tier
      when TIERS[0] then
        ENV['ADMIN_AUTH0_USERNAME']
      when TIERS[1] then
        ENV['INT_ADMIN_AUTH0_USERNAME']
      when TIERS[2] then
        ENV['UAT_ADMIN_AUTH0_USERNAME']
      when TIERS[3] then
        ENV['PROD_ADMIN_AUTH0_USERNAME']
      else
        ENV['ADMIN_AUTH0_USERNAME']
    end
  end

  def self.auth0_password
    case @tier
      when TIERS[0] then
        ENV['ADMIN_AUTH0_PASSWORD']
      when TIERS[1] then
        ENV['INT_ADMIN_AUTH0_PASSWORD']
      when TIERS[2] then
        ENV['UAT_ADMIN_AUTH0_PASSWORD']
      when TIERS[3] then
        ENV['PROD_ADMIN_AUTH0_PASSWORD']
      else
        ENV['ADMIN_AUTH0_PASSWORD']
    end
  end

  def self.auth0_database
    case @tier
      when TIERS[0] then
        ENV['AUTH0_DATABASE']
      when TIERS[1] then
        ENV['INT_AUTH0_DATABASE']
      when TIERS[2] then
        ENV['UAT_AUTH0_DATABASE']
      when TIERS[3] then
        ENV['PROD_AUTH0_DATABASE']
      else
        ENV['AUTH0_DATABASE']
    end
  end

  def self.auth0_domain
    ENV['AUTH0_DOMAIN']
  end
end