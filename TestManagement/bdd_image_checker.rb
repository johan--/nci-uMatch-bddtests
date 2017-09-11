require 'rest-client'

class BDDImageChecker
  def self.check(trigger_repo, trigger_commit)
    url = case trigger_repo
            when 'nci-match-patient-api' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/version'
            when 'nci-match-patient-state-api' then 'https://pedmatch-int.nci.nih.gov/api/v1/state_validator/version'
            when 'nci-match-patient-processor' then 'https://pedmatch-int.nci.nih.gov:3010/version'
            when 'nci-treatment-arm-api' then 'https://pedmatch-int.nci.nih.gov/api/v1/treatment_arms/version'
            when 'nci-treatment-arm-processor-api' then 'https://pedmatch-int.nci.nih.gov:10236/version'
            # when 'nci-match-rules' then 'https://pedmatch-int.nci.nih.gov/api/v1/rules/version'  #rule /version doesn't has commit number
            when 'nci-match-ion-reporters-api' then 'https://pedmatch-int.nci.nih.gov/api/v1/ion_reporters_api/version'
            when 'nci-match-sample-controls-api' then 'https://pedmatch-int.nci.nih.gov/api/v1/sample_controls_api/version'
            when 'nci-match-aliquots-api' then 'https://pedmatch-int.nci.nih.gov/api/v1/aliquots_api/version'
            else
              'OTHER'
          end
    if url == 'OTHER'
      puts "#{trigger_repo} doesn't need to check image, skip"
      return
    end
    int_commit = rest_get(url)['Commit']
    raise "Response from #{trigger_repo}/version doesn't has commit number!" if int_commit.nil?
    git_base_url = "https://api.github.com/repos/CBIIT/#{trigger_repo}/commits"
    int_commit_time = DateTime.parse(rest_get("#{git_base_url}/#{int_commit}")['commit']['committer']['date'])
    trigger_commit_time = DateTime.parse(rest_get("#{git_base_url}/#{trigger_commit}")['commit']['committer']['date'])
    puts "Image in INT:\n    Commit: #{int_commit}\n    Commit Time: #{int_commit_time}"
    puts "Travis Trigger:\n    Commit: #{trigger_commit}\n    Commit Time: #{trigger_commit_time}"
    if trigger_commit_time > int_commit_time
      raise 'Image in INT is older!'
    else
      puts 'Ready for BDD tests'
    end
  end

  def self.rest_get(url)
    response = RestClient::Request.execute(:url => url, :method => :get)
    raise "Cannot get response from #{url}!" unless response.code == 200
    JSON.parse(response)
  end
end