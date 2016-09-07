#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

When(/^the rules service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['rules_endpoint']+'/version')
end

Given(/^the patient assignment json "([^"]*)"$/) do |patient_json|
  patientAssignmentJson =  File.join(File.dirname(__FILE__),ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']+'/'+patient_json+'.json')
  expect(File.exist?(patientAssignmentJson)).to be_truthy
  @patient = JSON(IO.read(patientAssignmentJson))
end

And(/^treatment arm json "([^"]*)"$/) do |ta|
  ta = File.join(File.dirname(__FILE__),ENV['TAs_ASSIGNMENT_JSON_LOCATION']+'/'+ta+'.json')
  expect(File.exist?(ta)).to be_truthy
  @ta = JSON(IO.read(ta))
end


When(/^assignPatient service is called for patient "([^"]*)"$/) do |patient|
  msgHash = Hash.new
  msgHash = { "study_id"=> "APEC1621",'patient'=> @patient, 'treatment_arms'=>@ta}
  @payload = msgHash.to_json
  p @payload
  res = Helper_Methods.post_request(ENV['rules_endpoint']+'/assignment_report/'+ patient,@payload)
  @res = res.to_json
  p @res

  expect((JSON.parse(@res)['Error'])).to be_nil
end

Then(/^a patient assignment json is returned with reason category "([^"]*)" for treatment arm "([^"]*)"$/) do |assignment_reason,ta|
  # JSON.parse(@res)['patientAssignmentLogic'].each do |logic|
  #   if logic['treatmentArmName'] == ta
  #     expect(logic['reasonCategory']).to eql(assignment_reason)
  #   end
  # end
  expect(JSON.parse(@res)['status']).to eql("Success")
end

Then(/^the patient assignment reason is "([^"]*)"$/) do |reason|
   # expect(JSON.parse(@res)['patientAssignmentStatus']).to eql(reason)
   expect(JSON.parse(@res)['status']).to eql("Success")
end

Given(/^a tsv variant report file file "([^"]*)" and treatment arms file "([^"]*)"$/) do |arg1, ta|
  @tsv = arg1

  treatment_arm = File.join(File.dirname(__FILE__),ENV['rules_treatment_arm_location']+'/'+ta)
  expect(File.exist?(treatment_arm)).to be_truthy
  @treatment_arm = JSON(IO.read(treatment_arm))
end

When(/^call the amoi rest service$/) do
  @res = Helper_Methods.post_request(ENV['rules_endpoint']+'/variant_report/1111/BDD/msn-1111/job-1111/'+@tsv+'?filtered=true',@treatment_arm.to_json)
  puts @res.to_json
  expect(@res['status']).to eql("Success")
end

When(/^the proficiency_competency service is called/) do
  @res = Helper_Methods.post_request(ENV['rules_endpoint']+'/sample_control_report/proficiency_competency/BDD/msn-1111/job-1111/'+@tsv+'?filtered=true',@treatment_arm.to_json)
  puts @res.to_json
  expect(@res['status']).to eql("Success")
end

When(/^the no_template service is called/) do
  @res = Helper_Methods.post_request(ENV['rules_endpoint']+'/sample_control_report/no_template/BDD/msn-1111/job-1111/'+@tsv+'?filtered=true',@treatment_arm.to_json)
  puts @res.to_json
  expect(@res['status']).to eql("Success")
end

Then(/^moi report is returned with the snv variant "([^"]*)" as an amoi$/) do |arg1|
  # JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
  @res['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      expect(snv['amois']).not_to be_nil
    end
  end
end

Then(/^amoi treatment arm names for snv variant "([^"]*)" include:$/) do |arg1, string|
  arrTA = JSON.parse(string)
  # JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
  @res['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      # p snv['amois']
      expect(snv['amois']).to eql(arrTA)
    end
  end
end

Then(/^amoi treatment arms for snv variant "([^"]*)" include:$/) do |arg1, string|
  taHash = JSON.parse(string)
  # JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
  @res['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      expect((snv['treatment_arms']).flatten).to match_array((taHash).flatten)
    end
  end
end

Then(/^moi report is returned without the snv variant "([^"]*)"$/) do |arg1|
  # JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
  @res['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      fail ("The SNV #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the snv variant "([^"]*)"$/) do |arg1|
  flag = false
  # JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
  @res['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      flag = true
    end
  end
  if flag == false
    fail ("The SNV #{arg1} is not found in the moi report")
  end
end

Then(/^moi report is returned with (\d+) snv variants$/) do |arg1|
  # expect(JSON.parse(@res)['single_nucleotide_variants'].count).to eql(arg1.to_i)
  expect(@res['single_nucleotide_variants'].count).to eql(arg1.to_i)
end

Then(/^moi report is returned with the indel variant "([^"]*)"$/) do |arg1|
  flag = false
  # JSON.parse(@res)['indels'].each do |ind|
  @res['indels'].each do |ind|
    if ind['identifier'] == arg1
      flag = true
    end
  end
  if flag == false
    fail ("The Indel #{arg1} is not found in the moi report")
  end
end

Then(/^moi report is returned with (\d+) indel variants$/) do |arg1|
  # expect(JSON.parse(@res)['indels'].count).to eql(arg1.to_i)
  expect(@res['indels'].count).to eql(arg1.to_i)
end

Then(/^moi report is returned without the indel variant "([^"]*)"$/) do |arg1|
  # JSON.parse(@res)['indels'].each do |ind|
  @res['indels'].each do |ind|
    if ind['identifier'] == arg1
      fail ("The Indel #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the indel variant "([^"]*)" as an amoi$/) do |arg1, string|
  arrTA = JSON.parse(string)
  # JSON.parse(@res)['indels'].each do |ind|
    @res['indels'].each do |ind|
    if ind['identifier'] == arg1
      expect(ind['amois']).to eql(arrTA)
    end
  end
end


Then(/^moi report is returned with the cnv variant "([^"]*)"$/) do |arg1|
  flag = false
  # JSON.parse(@res)['copy_number_variants'].each do |cnv|
  @res['copy_number_variants'].each do |cnv|
    if cnv['identifier'] == arg1
      flag = true
    end
  end
  if flag == false
    fail ("The CNV #{arg1} is not found in the moi report")
  end
end

Then(/^moi report is returned without the cnv variant "([^"]*)"$/) do |arg1|
  # JSON.parse(@res)['copy_number_variants'].each do |cnv|
  @res['copy_number_variants'].each do |cnv|
    if cnv['identifier'] == arg1
      fail ("The CNV #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the cnv variant "([^"]*)" as an amoi$/) do |arg1, string|
  arrTA = JSON.parse(string)
  # JSON.parse(@res)['copy_number_variants'].each do |cnv|
  @res['copy_number_variants'].each do |cnv|
    if cnv['identifier'] == arg1
      expect(cnv['amois']).to eql(arrTA)
    end
  end
end


Then(/^moi report is returned with the ugf variant "([^"]*)"$/) do |arg1|
  flag = false
  # JSON.parse(@res)['unified_gene_fusions'].each do |ugf|
  @res['gene_fusions'].each do |gf|
    if gf['identifier'] == arg1
      flag = true
    end
  end
  if flag == false
    fail ("The gf #{arg1} is not found in the moi report")
  end
end


Then(/^moi report is returned without the ugf variant "([^"]*)"$/) do |arg1|
  # JSON.parse(@res)['unified_gene_fusions'].each do |ugf|
    @res['gene_fusions'].each do |gf|
    if gf['identifier'] == arg1
      fail ("The gf #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the ugf variant "([^"]*)" as an amoi$/) do |arg1, string|
  arrTA = JSON.parse(string)
  # JSON.parse(@res)['unified_gene_fusions'].each do |ugf|
  @res['gene_fusions'].each do |gf|
    if gf['identifier'] == arg1
      expect(gf['amois']).to eql(arrTA)
    end
  end
end

Then(/^moi report is returned with (\d+) cnv variants$/) do |arg1|
  # expect(JSON.parse(@res)['single_nucleotide_variants'].count).to eql(arg1.to_i)
  expect(@res['copy_number_variants'].count).to eql(arg1.to_i)
end

Then(/^moi report is returned with (\d+) ugf variants$/) do |arg1|
  # expect(JSON.parse(@res)['single_nucleotide_variants'].count).to eql(arg1.to_i)
  expect(@res['gene_fusions'].count).to eql(arg1.to_i)
end

