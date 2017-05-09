require_relative 'patient_message_loader'
require_relative 'treatment_arm_message_loader'
require_relative 'match_test_data_manager'


# Environment.setTier('local')
# puts Auth0Token.force_generate_auth0_token 'NCI_MATCH_READONLY'

# ############clear local dynamodb and load all existing seed data
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_seed_data_to_local('treatment_arm')
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


# Environment.setTier('local')
# TableDetails.all_tables.each { |this_table|
#   next if this_table=='treatment_arm_pending'
#   puts "\n\n\n#{this_table}:"
#   local = Helper_Methods.dynamodb_table_items(this_table)
#   local_id = []
#   int_id = []
#   id = TableDetails.primary_key(this_table)
#   local.each { |this_local| local_id << this_local[id] }
#   cmd = "aws dynamodb scan --table-name #{this_table} --endpoint-url https://dynamodb.us-east-1.amazonaws.com"
#   int = JSON.parse(`#{cmd}`)['Items']
#   int.each { |this_int| int_id << this_int[id]['S'] }
#   puts local_id-int_id
#   puts '################'
#   puts int_id - local_id
# }


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

# false_list = %w(PT_RA04a_NoTaAvailable PT_OS01a_NoTaAvailable PT_RA03_NoTaAvailable PT_RA02_NoTaAvailable PT_SS31_NoTaAvailable PT_OS01_NoTaAvailable PT_SR10_NoTaAvailable)
# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_patient.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# items.each{|this_item|
#   next unless this_item.has_key?('active_tissue_specimen')
#   next unless this_item['active_tissue_specimen']['M'].has_key?('active_analysis_id')
#   patient_id = this_item['patient_id']['S']
#   this_item['active_tissue_specimen']['M']['has_amoi'] = {'BOOL'=>!false_list.include?(patient_id)}
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


# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_patient.json"
# file_hash = JSON(IO.read(file))
# items = file_hash['Items']
# status = []
# items.each { |this_item|
#   unless status.include?(this_item['current_status']['S'])
#     status << this_item['current_status']['S']
#   end
# }
# puts status


# file = "#{File.dirname(__FILE__)}/seed_data_for_upload/match_bddtests_seed_data_sample_controls.json"
# file_string = IO.read(file)
# file_hash = JSON(file_string)
# items = file_hash['Items']
# sc_map = {}
# items.each { |this_item|
#   molecular_id = this_item['molecular_id']['S']
#   molecular_id = molecular_id.sub('SC_', '')
#   site = this_item['site']['S'].upcase
#   type = case this_item['control_type']['S']
#            when 'no_template' then
#              'NTC'
#            when 'positive' then
#              'SC'
#            when 'proficiency_competency' then
#              'PCC'
#            else
#              'SC'
#          end
#   new_molecular_id = "#{type}_#{site}_#{molecular_id}"
#  sc_map[molecular_id] = new_molecular_id
#   this_item['molecular_id']['S'] = new_molecular_id
# }
#
# File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }
# puts JSON.pretty_generate(sc_map)


# sc_list = {
#     "SC_SA1CB" => "NTC_MOCHA_SA1CB",
#     "SC_MCA05" => "NTC_MOCHA_MCA05",
#     "SC_3KSN8" => "NTC_MDA_3KSN8",
#     "SC_KGPVI" => "NTC_MOCHA_KGPVI",
#     "SC_307VJ" => "NTC_MDA_307VJ",
#     "SC_R2LAX" => "SC_MDA_R2LAX",
#     "SC_8SGBC" => "SC_MOCHA_8SGBC",
#     "SC_MDA00" => "NTC_MDA_MDA00",
#     "SC_WF2KR" => "NTC_MOCHA_WF2KR",
#     "SC_DTM00" => "NTC_DARTMOUTH_DTM00",
#     "SC_ZCCND" => "PCC_MDA_ZCCND",
#     "SC_2NSQL" => "PCC_DARTMOUTH_2NSQL",
#     "SC_DTM04" => "NTC_DARTMOUTH_DTM04",
#     "SC_R5H61" => "PCC_MDA_R5H61",
#     "SC_YQ111" => "NTC_MOCHA_YQ111",
#     "SC_LFCQP" => "NTC_MOCHA_LFCQP",
#     "SC_GP6TQ" => "PCC_MDA_GP6TQ",
#     "SC_MFIK1" => "NTC_MDA_MFIK1",
#     "SC_MDA04" => "NTC_MDA_MDA04",
#     "SC_DTM07" => "NTC_DARTMOUTH_DTM07",
#     "SC_MCA07" => "NTC_MOCHA_MCA07",
#     "SC_6VZBN" => "PCC_MDA_6VZBN",
#     "SC_DTM05" => "NTC_DARTMOUTH_DTM05",
#     "SC_CN8ZS" => "NTC_MOCHA_CN8ZS",
#     "SC_EP4AI" => "SC_MOCHA_EP4AI",
#     "SC_C8K7G" => "SC_MOCHA_C8K7G",
#     "SC_MDA05" => "NTC_MDA_MDA05",
#     "SC_HY9S5" => "SC_MOCHA_HY9S5",
#     "SC_7XM2S" => "NTC_MDA_7XM2S",
#     "SC_MDA06" => "NTC_MDA_MDA06",
#     "SC_CVLCZ" => "PCC_MDA_CVLCZ",
#     "SC_OAFXP" => "NTC_MDA_OAFXP",
#     "SC_MCA08" => "NTC_MOCHA_MCA08",
#     "SC_PALFC" => "SC_MOCHA_PALFC",
#     "SC_FVJ9A" => "NTC_DARTMOUTH_FVJ9A",
#     "SC_MDA08" => "NTC_MDA_MDA08",
#     "SC_VEME6" => "SC_MDA_VEME6",
#     "SC_LGUXF" => "PCC_MDA_LGUXF",
#     "SC_BKWJR" => "NTC_MDA_BKWJR",
#     "SC_Q5E0X" => "NTC_MDA_Q5E0X",
#     "SC_M4UAF" => "SC_MOCHA_M4UAF",
#     "SC_MCA04" => "NTC_MOCHA_MCA04",
#     "SC_9LL0Q" => "SC_MOCHA_9LL0Q",
#     "SC_6Y4FV" => "SC_MOCHA_6Y4FV",
#     "SC_YYQA3" => "SC_DARTMOUTH_YYQA3",
#     "SC_MDA07" => "NTC_MDA_MDA07",
#     "SC_DTM03" => "NTC_DARTMOUTH_DTM03",
#     "SC_4CPNX" => "NTC_MDA_4CPNX",
#     "SC_2KXJA" => "NTC_DARTMOUTH_2KXJA",
#     "SC_MCA06" => "NTC_MOCHA_MCA06",
#     "SC_LGU30" => "PCC_MDA_LGU30",
#     "SC_MCA01" => "NTC_MOCHA_MCA01",
#     "SC_N44B1" => "SC_MOCHA_N44B1",
#     "SC_K7IO0" => "SC_MOCHA_K7IO0",
#     "SC_DTM06" => "NTC_DARTMOUTH_DTM06",
#     "SC_QC422" => "SC_MOCHA_QC422",
#     "SC_JFCEO" => "SC_MOCHA_JFCEO",
#     "SC_C777Z" => "PCC_MOCHA_C777Z",
#     "SC_EUPC2" => "NTC_MOCHA_EUPC2",
#     "SC_DTM01" => "NTC_DARTMOUTH_DTM01",
#     "SC_FDK09" => "PCC_MOCHA_FDK09",
#     "SC_AWBSY" => "NTC_MOCHA_AWBSY",
#     "SC_MCA03" => "NTC_MOCHA_MCA03",
#     "SC_BAXXY" => "PCC_MDA_BAXXY",
#     "SC_NPID3" => "NTC_MDA_NPID3",
#     "SC_XPCQG" => "SC_MOCHA_XPCQG",
#     "SC_2A9FY" => "PCC_MDA_2A9FY",
#     "SC_XZD70" => "PCC_MDA_XZD70",
#     "SC_DM9AU" => "PCC_DARTMOUTH_DM9AU",
#     "SC_73JIO" => "SC_MOCHA_73JIO",
#     "SC_43K8V" => "NTC_MDA_43K8V",
#     "SC_MCA09" => "NTC_MOCHA_MCA09",
#     "SC_IEWC6" => "PCC_MDA_IEWC6",
#     "SC_J6RDR" => "NTC_MDA_J6RDR",
#     "SC_C8VQ0" => "SC_DARTMOUTH_C8VQ0",
#     "SC_ZO9VD" => "NTC_MDA_ZO9VD",
#     "SC_MDA01" => "NTC_MDA_MDA01",
#     "SC_MDA02" => "NTC_MDA_MDA02",
#     "SC_LL7IZ" => "PCC_MDA_LL7IZ",
#     "SC_76HQS" => "SC_MOCHA_76HQS",
#     "SC_A2PD6" => "SC_MOCHA_A2PD6",
#     "SC_NUWQS" => "NTC_MDA_NUWQS",
#     "SC_4Y49T" => "NTC_MDA_4Y49T",
#     "SC_D8ZTD" => "PCC_MDA_D8ZTD",
#     "SC_67VKV" => "SC_MOCHA_67VKV",
#     "SC_MDA09" => "NTC_MDA_MDA09",
#     "SC_VNTE5" => "NTC_MDA_VNTE5",
#     "SC_O20H9" => "SC_DARTMOUTH_O20H9",
#     "SC_MDA03" => "NTC_MDA_MDA03",
#     "SC_5AMCC" => "SC_MOCHA_5AMCC",
#     "SC_QSQTO" => "SC_MOCHA_QSQTO",
#     "SC_MCA00" => "NTC_MOCHA_MCA00",
#     "SC_X9FR1" => "SC_MOCHA_X9FR1"
# }

# target_folders = {}
#
# Helper_Methods.s3_list_files('pedmatch-dev', '').each { |this_path|
#   parts = this_path.split('/')
#   old_folder = "#{parts[0]}/#{parts[1]}/"
#   sc_list.each_key { |this_sc|
#     if old_folder.include?("/#{this_sc}/") && !target_folders.has_key?(old_folder)
#       target_folders["#{parts[0]}/#{parts[1]}"] = "#{parts[0]}/#{sc_list[parts[1]]}"
#     end
#   }
# }
# target_folders.each{|k, v|
#   cmd = "aws s3 mv --recursive s3://pedmatch-dev/#{k} s3://pedmatch-dev/#{v}"
#   `#{cmd}`
# }

# target_folders2 = {}
#
# Helper_Methods.s3_list_files('pedmatch-int', '').each { |this_path|
#   parts = this_path.split('/')
#   old_folder = "#{parts[0]}/#{parts[1]}/"
#   sc_list.each_key { |this_sc|
#     if old_folder.include?("/#{this_sc}/") && !target_folders2.has_key?(old_folder)
#       target_folders2["#{parts[0]}/#{parts[1]}"] = "#{parts[0]}/#{sc_list[parts[1]]}"
#     end
#   }
# }
# target_folders2.each{|k, v|
#   cmd = "aws s3 mv --recursive s3://pedmatch-int/#{k} s3://pedmatch-int/#{v}"
#   puts `#{cmd}`
# }

patients = ["PT_SS27_VariantReportUploaded",
            "PT_VU09_VariantReportUploaded",
            "PT_AU11_MochaTsShipped",
            "PT_CR02_OnTreatmentArm",
            "PT_AU03_SlideShipped0",
            "PT_RA03_TsShipped",
            "PT_AS08_TissueReceived",
            "PT_AS12_VrConfirmed",
            "PT_AM01_TsVrReceived1",
            "PT_AS09_OffStudy",
            "PT_AS09_OffStudyBiopsyExpired",
            "PT_AS09_ReqNoAssignment",
            "PT_SS26_RequestAssignment",
            "PT_SS31_CompassionateCare",
            "PT_SS31_NoTaAvailable",
            "PT_AS12_PendingConfirmation",
            "PT_AM03_PendingApproval",
            "PT_AS12_OnTreatmentArm",
            "PT_CR04_VRUploadedAssayReceived",
            "PT_CR04_VRUploadedAssayReceived",
            "PT_CR04_VRUploadedAssayReceived",
            "PT_CR07_RejectVariantReport",
            "PT_CR06_RejectOneVariant",
            "PT_CR03_VRUploadedPathConfirmed",
            "PT_CR01_PathAssayDoneVRUploadedToConfirm",
            "PT_CR01_PathAssayDoneVRUploadedToConfirm",
            "PT_CR01_PathAssayDoneVRUploadedToConfirm",
            "PT_UI04_DtmTsShipped1",
            "PT_UI04_DtmTsShipped1",
            "PT_UI04_DtmTsShipped1",
            "PT_AU04_MdaTsShipped1",
            "PT_AU04_MdaTsShipped1",
            "PT_AU04_MdaTsShipped1",
            "PT_AU04_MochaTsShipped1",
            "PT_SR10_CompassionateCare",
            "PT_AS00_SlideShipped4",
            "PT_RA03_NoTaAvailable",
            "PT_AU04_MochaTsShipped1",
            "PT_AU04_MochaTsShipped1",
            "PT_AM05_TsVrReceived1",
            "PT_CR05_SpecimenShippedTwice",
            "PT_CR05_SpecimenShippedTwice",
            "PT_SR10_ProgressReBioY",
            "PT_RA04a_TsShipped",
            "PT_RA06_OnTreatmentArm",
            "PT_OS03_OffStudy1",
            "PT_SC04b_PendingApproval",
            "PT_GVF_RequestNoAssignment",
            "PT_SC01c_TsVrUploadedStep2"]

MatchTestDataManager.copy_patients_from_tag_to_tag(patients.uniq, 'patients', 'ui')