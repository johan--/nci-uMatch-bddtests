#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
@@ctr = 1

When(/^the rules service \/version is called$/) do
  @res=Helper_Methods.get_request("#{ENV['rules_endpoint']}/version", {}, false)
end

Then(/^the version "([^"]*)" is returned as json$/) do |version|
  expect(@res['http_code']).to eql(200)
  message = JSON.parse(@res['message'])
  expect(message['version']).to include(version)
end

Given(/^the patient assignment json "([^"]*)"$/) do |patient_json|
  patientAssignmentJson = File.join(File.dirname(__FILE__), "#{ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']}/#{patient_json}.json")
  expect(File.exist?(patientAssignmentJson)).to be_truthy
  @patient = JSON(IO.read(patientAssignmentJson))
end

And(/^treatment arm json "([^"]*)"$/) do |ta|
  ta = File.join(File.dirname(__FILE__), "#{ENV['TAs_ASSIGNMENT_JSON_LOCATION']}/#{ta}.json")
  expect(File.exist?(ta)).to be_truthy
  @ta = JSON(IO.read(ta))
end


When(/^assignPatient service is called for patient "([^"]*)"$/) do |patient|
  msgHash = Hash.new
  msgHash = {"study_id" => "APEC1621SC", 'patient' => @patient, 'treatment_arms' => @ta}
  @payload = msgHash.to_json
  puts @payload
  @resp = Helper_Methods.post_request("#{ENV['rules_endpoint']}/assignment_report/#{patient}", @payload)
  @res = @resp['http_code'] =='200' ? JSON.parse(@resp['message']) : fail("Error #{@resp['http_code']} is returned by the server")
  puts @res
end

Then(/^a patient assignment json is returned with reason category "([^"]*)" for treatment arm "([^"]*)"$/) do |assignment_reason, ta|
  assignment_result = @res['treatment_assignment_results']
  assignment_result.each do |tas|
    responseTA = tas['treatment_arm_id']
    if responseTA.eql? ta
      expect(tas['assignment_status']).to eql(assignment_reason)
    end
  end
end

Then(/^a patient assignment json is returned with report_status "([^"]*)"$/) do |status|
  expect(@res['report_status']).to eql(status)
  # File.open("assignment_reason_#{@@ctr}.json", 'w') { |file| file.puts(@res.to_json) }
  #
  # @@ctr = @@ctr+1
  # temporary way to print all assignment reasons
  # assignment_result = @res['treatment_assignment_results']
  # assignment_result.each do |tas|
  #   File.open('assignment_reason.txt', 'a') { |file| file.puts(tas['reason']+'\n') }
  # end
  #   ends here
end

Then(/^the patient assignment reason is "([^"]*)"$/) do |reason|
  assignment_result = @res['treatment_assignment_results']
  assignment_result.each do |tas|
    puts tas['reason']
    expect(tas['reason']).to include(reason)
  end
end

Given(/^a tsv variant report file "([^"]*)" and treatment arms file "([^"]*)"$/) do |arg1, ta|
  @tsv = arg1
  treatment_arm = File.join(File.dirname(__FILE__), ENV['rules_treatment_arm_location']+'/'+ta)
  expect(File.exist?(treatment_arm)).to be_truthy
  @treatment_arm = JSON(IO.read(treatment_arm))
  p @treatment_arm
end

When(/^call the amoi rest service$/) do
  @resp = Helper_Methods.post_request("#{ENV['rules_endpoint']}/variant_report/1111/BDD/msn-1111/job-1111/#{@tsv}?format=tsv", @treatment_arm.to_json)
  @res = JSON.parse(@resp['message'])
  puts JSON.pretty_generate(@res)
  @var_report = @res
end

When(/^remove quality control json from S3$/) do
  bucket = ENV['s3_bucket']
  json_path = "BDD/msn-1111/job-1111/#{@tsv}.json"
  Helper_Methods.s3_delete_path(bucket, json_path)
  raise "#{json_path} cannot be deleted properly" if Helper_Methods.s3_file_exists(bucket, json_path)
end

When(/^quality control json file should be generated$/) do
  bucket = ENV['s3_bucket']
  json_path = "BDD/msn-1111/job-1111/#{@tsv}.json"
  wait_time = 0
  exist = false
  while wait_time < 35
    exist = Helper_Methods.s3_file_exists(bucket, json_path)
    if exist
      break
    end
    wait_time += 5.0
  end
  expect(exist).to eq true
  @qc_report = JSON.parse(Helper_Methods.s3_read_text_file(bucket, json_path))
end

And(/^following variants can be found in quality control json$/) do |table|
  table.hashes.each do |params|
    pick = @qc_report[params['category']].select do |v|
      select = true
      params.each do |key, value|
        next if key == 'category'
        select = select && v[key] == value
      end
      select
    end
    puts "Searching variant #{params.to_json}, result should be 1"
    expect(pick.size).to be == 1
  end
end

And(/^the generated qc json should have these cnv genes$/) do |table|
  params = table.hashes
  expect(@qc_report.keys).to include 'copy_number_variant_genes'
  cnv_genes = @qc_report['copy_number_variant_genes']
  params.each do |this_param|
    gene = this_param['gene']
    selected = cnv_genes.select { |x| x['gene']==gene }
    expect(selected.size).to be == 1
    this_param.each do |k, v|
      expect_v = selected[0][k]
      if Helper_Methods.is_number?(expect_v)
        expect(expect_v.to_f).to eq v.to_f
      else
        expect(expect_v.to_s).to eq v.to_s
      end
    end
  end
end

And(/^the generated qc json should have these cnv variants$/) do |table|
  params = table.hashes
  expect(@qc_report.keys).to include 'copy_number_variants'
  cnv_vrs = @qc_report['copy_number_variants']
  params.each do |this_param|
    identifier = this_param['identifier']
    selected = cnv_vrs.select { |x| x['identifier']==identifier }
    expect(selected.size).to be == 1
    this_param.each do |k, v|
      expect_v = selected[0][k]
      if Helper_Methods.is_number?(v)
        expect(expect_v.to_f).to be == v.to_f
      else
        expect(expect_v.to_s).to eq v
      end
    end
  end
end

When(/^the proficiency_competency service is called/) do
  @resp = Helper_Methods.post_request("#{ENV['rules_endpoint']}/sample_control_report/proficiency_competency/BDD/msn-1111/job-1111/#{@tsv}?format=tsv", @treatment_arm.to_json)
  @res = JSON.parse(@resp['message'])
  puts @res
end

When(/^the no_template service is called/) do
  # @res = Helper_Methods.post_request(ENV['rules_endpoint']+'/sample_control_report/no_template/BDD/msn-1111/job-1111/'+@tsv+'?filtered=true',@treatment_arm.to_json)
  @resp = Helper_Methods.post_request("#{ENV['rules_endpoint']}/sample_control_report/no_template/BDD/msn-1111/job-1111/#{@tsv}?format=tsv", @treatment_arm.to_json)
  @res = JSON.parse(@resp['message'])
  puts @res
end

When(/^the positive_control service is called/) do
  @resp = Helper_Methods.post_request("#{ENV['rules_endpoint']}/sample_control_report/positive/BDD/msn-1111/job-1111/#{@tsv}?format=tsv", @treatment_arm.to_json)
  @res = JSON.parse(@resp['message'])
  puts @res
end

Then(/^the report status return is "([^"]*)"$/) do |status|
  expect(@res['report_status']).to eql(status)
end

Then(/^the report type return is "([^"]*)"$/) do |type|
  expect(@res['variant_report_type']).to eql(type)
end

Then(/^moi report is returned with the snv variant "([^"]*)" as an amoi$/) do |arg1|
  found = false
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == arg1
      found = true
      expect(snv['amois']).not_to be_nil
      expect(snv['amois'].size).to be > 0
    end
  end
  raise "Cannot find variant #{arg1}" unless found
end

Then(/^returned moi report should not have snv variant "([^"]*)"$/) do |id|
  found = false
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == id
      found = true
      break
    end
  end
  raise "Variant #{id} is found in returned moi report" if found
end

Then(/^in moi report the snv variant "([^"]*)" has "([^"]*)" amois$/) do |variant, count|
  found = false
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == variant
      found = true
      expect(snv['amois']).not_to be_nil
      expect(snv['amois'].size).to eq count.to_i
    end
  end
  raise "Cannot find variant #{variant}" unless found
end

Then(/^in moi report the snv variant "([^"]*)" type is "([^"]*)"$/) do |variant, type|
  found = false
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == variant
      found = true
      expect(snv['variant_type']).not_to be_nil
      expect(snv['variant_type']).to eq type
    end
  end
  raise "Cannot find variant #{variant}" unless found
end

Then(/^amoi treatment arm names for snv variant "([^"]*)" include:$/) do |arg1, string|
  arrTA = JSON.parse(string)
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == arg1
      # p snv['amois']
      expect(snv['amois']).to eql(arrTA)
    end
  end
end

Then(/^amoi treatment arms for snv variant "([^"]*)" include:$/) do |arg1, string|
  taHash = JSON.parse(string)
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == arg1
      expect((snv['treatment_arms']).flatten).to match_array((taHash).flatten)
    end
  end
end

Then(/^moi report is returned without the snv variant "([^"]*)"$/) do |arg1|
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == arg1
      fail ("The SNV #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the snv variant "([^"]*)"$/) do |arg1|
  flag = false
  ctr = 0
  @res['snv_indels'].each do |snv|
    if snv['identifier'] == arg1
      flag = true
      ctr = ctr+1
    end
  end
  if ctr > 1
    fail ("The SNV #{arg1} is found #{ctr} times. Duplicates exists")
  else
    p "The SNV #{arg1} is found #{ctr} times"
  end
  if flag == false
    fail ("The SNV #{arg1} is not found in the moi report")
  end
end

Then(/^moi report is returned with (\d+) snv variants$/) do |arg1|
  expect(@res['snv_indels'].count).to eql(arg1.to_i)
end

Then(/^false positive variants is returned with (\d+) variants$/) do |arg1|
  expect(@res['false_positive_variants'].count).to eql(arg1.to_i), "Expected #{arg1} but found #{@res['false_positive_variants'].count}"
end

And(/^match is false for "([^"]*)" variants in the positive variants$/) do |arg1|
  @res["positive_variants"].each do |var|
    if var["hgvs"].eql?(arg1)
      expect(var["match"]).to eql(false), "Identifier with hgvs: '#{var['hgvs']}' has a value of true"
    end
  end
end

Then(/^the gene "([^"]*)" is filtered out from the positive control variant report$/) do |gene|
  @res["positive_variants"].each do |var|
    expect(var["gene"]).not_to eql(gene), "Gene: '#{var['gene']}' appears in the positive control variant report"
  end
end

Then(/^variant type "([^"]*)" with "([^"]*)" is found in the False positives table$/) do |arg1, arg2|
  flag = false
  @res['false_positive_variants'].each do |var|
    if (var['variant_type'].eql?(arg1.downcase) & var['identifier'].eql?(arg2))
      flag = true
      break
    end
  end
  if flag == false
    fail("The variant of type #{arg1} and identifier #{arg2} is not found in the false positives")
  end
end

Then(/^variant type "([^"]*)" with "([^"]*)" not is found in the False positives table$/) do |arg1, arg2|
  flag = false
  @res['false_positive_variants'].each do |var|
    if (var['variant_type'].eql?(arg1.downcase) & var['identifier'].eql?(arg2))
      flag = true
      break
    end
  end
  if flag == true
    fail("The variant of type #{arg1} and identifier #{arg2} is found in the false positives")
  end
end

Then(/^positive variants is returned with (\d+) variants$/) do |arg1|
  expect(@res['positive_variants'].count).to eql(arg1.to_i)
end

And(/^match is true for "([^"]*)" variants in the positive variants$/) do |arg1|
  if arg1 == "all"
    @res["positive_variants"].each do |var|
      expect(var["match"]).to eql(true), "Identifier: '#{var['identifier']}' has a value of false"
    end
  end

end

Then(/^moi report is returned with the indel variant "([^"]*)"$/) do |arg1|
  flag = false
  @res['snv_indels'].each do |ind|
    if ind['identifier'] == arg1
      flag = true
    end
  end
  if flag == false
    fail ("The Indel #{arg1} is not found in the moi report")
  end
end

Then(/^moi report is returned with (\d+) indel variants$/) do |arg1|
  expect(@res['snv_indels'].count).to eql(arg1.to_i)
end

Then(/^moi report is returned without the indel variant "([^"]*)"$/) do |arg1|
  @res['snv_indels'].each do |ind|
    if ind['identifier'] == arg1
      fail ("The Indel #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the indel variant "([^"]*)" as an amoi$/) do |arg1, string|
  arrTA = JSON.parse(string)
  @res['snv_indels'].each do |ind|
    if ind['identifier'] == arg1
      expect(ind['amois']).to eql(arrTA)
    end
  end
end

Then(/^moi report is returned with indel variants with following amoi information$/) do |table|
  params = table.hashes
  params.each do |param|
    find = @res['snv_indels'].select {|v| v['identifier']==param['id']&&v['protein']==param['protein']}
    expect(find.size).to be 1
    target = find[0]
    if param['is_amoi']=='true'
      expect(target['amois'].size).to be > 0
      amoi = target['amois'][0]
      expect(amoi['treatment_arm_id'].to_s).to eq param['amoi_ta_id']
      expect(amoi['stratum_id'].to_s).to eq param['amoi_ta_stratum']
      expect(amoi['version'].to_s).to eq param['amoi_ta_version']
      expect(amoi['amoi_status'].to_s).to eq param['amoi_status']
      expect(amoi['exclusion'].to_s).to eq param['amoi_exclusion']
    else
      expect(target['amois'].size).to be 0
    end
  end
end


Then(/^moi report is returned with the cnv variant "([^"]*)"$/) do |arg1|
  flag = false
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
  @res['copy_number_variants'].each do |cnv|
    if cnv['identifier'] == arg1
      fail ("The CNV #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the cnv variant "([^"]*)" as an amoi$/) do |arg1, string|
  arrTA = JSON.parse(string)
  @res['copy_number_variants'].each do |cnv|
    if cnv['identifier'] == arg1
      expect(cnv['amois']).to eql(arrTA)
    end
  end
end


Then(/^moi report is returned with the ugf variant "([^"]*)"$/) do |arg1|
  flag = false
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
  @res['gene_fusions'].each do |gf|
    if gf['identifier'] == arg1
      fail ("The gf #{arg1} is found in the moi report")
    end
  end
end

Then(/^the returned moi reoprt ugf variant "([^"]*)" should have these values$/) do |ugf_id, table|
  flag = false
  @res['gene_fusions'].each do |gf|
    if gf['identifier'] == ugf_id
      table.hashes.each { |this_set|
        field = this_set['field']
        value = this_set['value']=='null' ? nil : this_set['value']
        expect(gf[field].to_s).to eq value
      }
      flag = true
    end
  end
  fail ("The gf #{ugf_id} is not found in the moi report") unless flag
end

Then(/^moi report is returned with the ugf variant "([^"]*)" as an amoi$/) do |arg1, string|
  arrTA = JSON.parse(string)
  @res['gene_fusions'].each do |gf|
    if gf['identifier'] == arg1
      expect(gf['amois']).to eql(arrTA)
    end
  end
end

Then(/^moi report is returned with (\d+) cnv variants$/) do |arg1|
  expect(@res['copy_number_variants'].count).to eql(arg1.to_i)
end

Then(/^moi report is returned with (\d+) ugf variants$/) do |arg1|
  expect(@res['gene_fusions'].count).to eql(arg1.to_i)
end

When(/^a new treatment arm list "([^"]*)" is received by the rules amoi service for the above variant report$/) do |ta|
  treatment_arm = File.join(File.dirname(__FILE__), ENV['rules_treatment_arm_location']+'/'+ta)
  expect(File.exist?(treatment_arm)).to be_truthy, "File not found"
  @treatment_arm_list = JSON(IO.read(treatment_arm))
  variantReportHash = {"variant_report" => @var_report, "treatment_arms" => @treatment_arm_list}
  puts variantReportHash.to_json

  @resp = Helper_Methods.put_request("#{ENV['rules_endpoint']}/variant_report/amois", variantReportHash.to_json)
  @res = JSON.parse(@resp['message'])
  puts @res
end

Then(/^moi report is returned without the cnv gene "([^"]*)"$/) do |arg1|
  @res['copy_number_variant_genes'].each do |cnv|
    p cnv['gene']
    if cnv['gene'] == arg1
      fail("copy number gene #{arg1} with filter NOCALL is returned as part of the variant report")
    end
  end
end

Then(/^moi report is returned with the cnv gene "([^"]*)"$/) do |arg1|
  flag = "N"
  @res['copy_number_variant_genes'].each do |cnv|
    p cnv['gene']
    if cnv['gene'] == arg1
      flag = "Y"
    end
  end
  if flag == "N"
    fail("copy number gene #{arg1} with filter PASS is not returned as part of the variant report")
  end
end

Then(/^the variant report contains poolsum in oncomine panel summary with$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  pool_sum = @res['oncomine_control_panel_summary']
  table.rows_hash.each {|k, v| check_pool_values(pool_sum, k, v.to_f)}
end

Then(/^the variant report contains exprControl in oncomine panel summary with$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  ec_pool = @res['oncomine_control_panel_summary']['ecPool']
  table.rows_hash.each {|k, v| check_pool_values(ec_pool, k, v.to_f)}
end

Then(/^the variant report contains geneExpression in oncomine panel summary with$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  ge_pool = @res['oncomine_control_panel_summary']['gePool']
  table.rows_hash.each {|k, v| check_pool_values(ge_pool, k, v.to_f)}
end

Then(/^the variant report contains fusion in oncomine panel summary with$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  f_pool = @res['oncomine_control_panel_summary']['fPool']
  table.rows_hash.each {|k, v| check_pool_values(f_pool, k, v.to_f)}
end

def check_pool_values(hash, pool_key, pool_value)
  actual_value = nil
  hash.each do |k, v|
    if k.downcase == pool_key.downcase
      actual_value = v
    end
  end
  expect(actual_value).to eql(pool_value)
end

Then(/^the parsed vcf genes should match the list "([^"]*)"$/) do |geneList|
  genes_notfound = []
  gene_list = File.readlines("#{ENV['GENE_LIST_FILE_LOCATION']}#{geneList}")
  # res = JSON.parse(@res)
  parsedCopyNumberGenes = @res["copy_number_variant_genes"]
  parsedCopyNumberGenes.each do |gl|
    if !gene_list.include? ("#{gl["gene"]}\n")
      genes_notfound.insert(-1, gl['gene'])
    else
      p "gene #{gl['gene']} found"
    end
  end
  if genes_notfound.count > 0
    fail "The following gene(s) #{genes_notfound.to_s} are not found"
  end
end

Then(/^the variant report contains the following values$/) do |table|
  tvc_version = table.rows_hash['torrent_variant_caller_version']
  mapd = table.rows_hash['mapd']
  # res = JSON.parse(@res)
  expect(@res['torrent_variant_caller_version']).to eql(tvc_version)
  expect(@res['mapd']).to eql(mapd)
end


