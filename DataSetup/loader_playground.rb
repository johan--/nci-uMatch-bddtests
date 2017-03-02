require_relative 'patient_message_loader'
require_relative 'treatment_arm_message_loader'
require_relative 'match_test_data_manager'


# Environment.setTier('local')
# puts Auth0Token.force_generate_auth0_token 'NCI_MATCH_READONLY'

# ############clear local dynamodb and load all existing seed data
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local
# MatchTestDataManager.clear_all_pressure_seed_files
# MatchTestDataManager.generate_patient_instance('PT_TMP_AssayReceived', 1000)
# MatchTestDataManager.generate_patient_instance('PT_TMP_Registered', 1000)
# MatchTestDataManager.generate_patient_instance('PT_TMP_SlideShipped', 1000)
# MatchTestDataManager.generate_patient_instance('PT_TMP_TsReceived', 1000)
# MatchTestDataManager.generate_patient_instance('PT_TMP_TsShipped', 1000)
# MatchTestDataManager.clear_all_local_tables
# MatchTestDataManager.upload_pressure_data_to_int

#################backup the just generated local db
# MatchTestDataManager.backup_all_local_db
# MatchTestDataManager.backup_all_patient_local_db
# MatchTestDataManager.backup_all_ion_local_db
# MatchTestDataManager.backup_all_ta_local_db


############clear aws dynamodb and load all seed data
# MatchTestDataManager.clear_all_int_tables
# MatchTestDataManager.upload_all_seed_data_to_int


# MatchTestDataManager.delete_patients_from_seed('patient_id')


# /api/v1/patients/statistics(.:format)
# /api/v1/patients/pending_items(.:format)
# /api/v1/patients/amois(.:format)
# /api/v1/patients/events(.:format)
# /api/v1/patients/variant_reports(.:format)
# /api/v1/patients/variants(.:format)
# /api/v1/patients/assignments(.:format)
# /api/v1/patients/shipments(.:format)
# /api/v1/patients/patient_limbos(.:format)
# /api/v1/patients/specimens(.:format)
# /api/v1/patients(.:format)
#
#
# /api/v1/patients/events/:id(.:format)
# /api/v1/patients/variant_reports/:id(.:format)
# /api/v1/patients/variants/:id(.:format)
# /api/v1/patients/assignments/:id(.:format)
# /api/v1/patients/shipments/:id(.:format)
# /api/v1/patients/:id(.:format)
#
#
#
#
# /api/v1/patients/:patient_id/action_items(.:format)
# /api/v1/patients/:patient_id/treatment_arm_history(.:format)
# /api/v1/patients/:patient_id/specimens(.:format)
# /api/v1/patients/:patient_id/specimen_events(.:format)
#
#
#
#
#
# /api/v1/patients/:patient_id/specimens/:id(.:format)
# /api/v1/patients/:patient_id/analysis_report/:id(.:format)
# /api/v1/patients/:patient_id/analysis_report_amois/:id(.:format)
# /api/v1/patients/:patient_id/qc_variant_reports/:id(.:format)
# /api/v1/patients/:patient_id/variant_file_download/:id(.:format)


# file_detail = JSON(IO.read('/Users/wangl17/Downloads/files.2017-01-25T17-37-55.130042.json'))
# case_detail = JSON(IO.read('/Users/wangl17/Downloads/cases.2017-01-25T17-49-51.499691.json'))
#
# output = ''
#
# file_detail.each { |this_file|
#   file_name = this_file['file_name']
#   this_line = "#{file_name}"
#   this_file['cases'].each { |this_case|
#     case_id = this_case['case_id']
#     related_case = case_detail.select{|o| o['case_id']==case_id}
#     case_barcode = case_id
#     if related_case.present?
#       puts "#{case_id} has #{related_case.size} case details" if related_case.size>1
#       case_barcode = related_case[0]['submitter_id']
#     end
#     this_line += "\t#{case_barcode}"
#   }
#   output += "#{this_line}\n"
# }
#
# puts output

# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_specimen.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# items.each{|this_item|
#   collect_dt = DateTime.parse(this_item['collected_date']['S'])
#   received_dttm = collect_dt + 1.days
#   received_dttm_hash = {'S'=>received_dttm.iso8601}
#   this_item['received_date'] = received_dttm_hash
# }
# File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }

#
# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_patient.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# items.each{|this_item|
#   next unless this_item.has_key?('active_tissue_specimen')
#   active_specimen = this_item['active_tissue_specimen']['M']
#   next unless active_specimen.has_key?('specimen_collected_date')
#   collect_dt = DateTime.parse(active_specimen['specimen_collected_date']['S'])
#   received_dttm = collect_dt + 1.days
#   received_dttm_hash = {'S'=>received_dttm.iso8601}
#   this_item['active_tissue_specimen']['M']['specimen_received_date'] = received_dttm_hash
# }
# File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }

# false_list = %w(PT_RA04a_NoTaAvailable PT_OS01a_NoTaAvailable PT_RA03_NoTaAvailable PT_RA02_NoTaAvailable PT_SS31_NoTaAvailable_ANI1 PT_OS01_NoTaAvailable_ANI1 PT_SR10_NoTaAvailable_ANI1)
# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_patient.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# items.each{|this_item|
#   if this_item.has_key?('active_analysis_id')
#     puts this_item['patient_id']['S']
#   end
#   # next unless this_item.has_key?('active_tissue_specimen')
#   # next unless this_item['active_tissue_specimen']['M'].has_key?('active_analysis_id')
#   # patient_id = this_item['patient_id']['S']
#   # this_item['active_tissue_specimen']['M']['has_amoi'] = {'BOOL'=>!false_list.include?(patient_id)}
# }
# File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }

# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_treatment_arm_assignment_event.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# items.each{|this_item|
# this_item['treatment_arm_status'] = {'S' => 'OPEN'}
#   if this_item['assignment_reason'].nil?
#     if this_item.keys.include?('assignment_report')
#       if this_item['assignment_report']['M'].keys.include?('selected_treatment_arm')
#         this_item['assignment_reason'] = this_item['assignment_report']['M']['selected_treatment_arm']['M']['reason']
#       end
#     end
#   end
# }
# File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }

# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_treatment_arm_assignment_event.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# items.each { |this_item|
#   raise "#{this_item['patient_id']} has no patient_status" unless this_item.keys.include?('patient_status')
#   if this_item['patient_status']['S'] == 'PREVIOUSLY_ON_ARM' || this_item['patient_status']['S'] == 'NOT_ENROLLED_ON_ARM'
#     this_item['patient_status_reason'] = {'S': 'Physician determines it is not in the patient’s best interest.'}
#     this_item['assignment_reason'] = {'NULL': true}
#   else
#     this_item['patient_status'] == {'NULL': true}
#   end
# }
# File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }