# require 'HTTParty'
# require 'nci_match_patient_models'
#
# class PatientLoader
#   include HTTParty
#
#   # cmd line: ruby -r "./patient_loader.rb" -e "PatientLoader.load_patient '3344'"
#   def self.load_patient_to_local(patient_id, wait_time)
#     p "Loading patient #{patient_id}"
#     raise 'patient_id must be valid' if patient_id.nil? || patient_id.length == 0
#     file = File.read("patients/#{patient_id}.json")
#
#     message_list = JSON.parse(file)
#     p "There are #{message_list.length} json messages in patient json file. Processing..."
#
#     all_items = 0
#     failure = 0
#     fail_list = 'Failed message IDs: '
#     message_list.each do |message|
#       all_items += 1
#       p ''
#       # p "Loading message #{message.to_json}..."
#       if message.key?('sleep')
#         p "Sleep for #{message['sleep']} seconds"
#         sleep(message['sleep'].to_f)
#       else
#         service_name = 'trigger'
#
#         curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\" -H \"Accept: application/json\"  -d '" + message.to_json + "' http://localhost:10240/" + service_name
#         p ''
#
#         output = `#{curl_cmd}`
#         p ''
#         p "Output from running curl: #{output}"
#         unless output.downcase.include?'success'
#           p 'Failed'
#           puts JSON.pretty_generate(message)
#           failure += 1
#           fail_list = "#{fail_list} No.#{all_items}"
#         end
#         sleep(wait_time)
#       end
#     end
#
#     pass = all_items - failure
#     p ''
#     p "#{all_items} messages processed, #{pass} passed and #{failure} failed"
#   end
#
#   def self.configure
#     Aws.config.update({
#                           endpoint: 'https://dynamodb.us-east-1.amazonaws.com',
#                           access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#                           secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#                           region: 'us-east-1'
#                       })
#   end
#
#
#   def self.backup_local_db(table_name)
#     cmd = "aws dynamodb scan --table-name #{table_name} --endpoint-url http://localhost:8000 > ../DataSetup/patient_seed_data/nci_match_bddtests_#{table_name}_seed_data.json"
#     `#{cmd}`
#   end
#
#   def self.local_backup_to_aws(table_name)
#     class_name = "NciMatchPatientModels::#{table_name.camelize}"
#     clazz = class_name.constantize
#     clazz.send('set_table_name', table_name.downcase)
#     local_json = JSON.parse(File.read("nci_match_bddtests_#{table_name}_seed_data.json"))
#     items = local_json['Items']
#     items.each do |this_item|
#       this_instance = class_name.constantize.new
#       this_item.keys.each do |key|
#
#         if this_item[key].keys.length != 1
#           p "#{class_name}-#{key} has #{this_item[key].keys.length} keys"
#           return
#         end
#
#         if this_item[key].keys[0]=='NULL' #this value is null
#           next
#         end
#
#         acceptable_keys = %w(M S BOOL N)
#         unless acceptable_keys.include?(this_item[key].keys[0])
#           p "#{class_name}-#{key} has invalid key #{this_item[key].keys[0]}"
#           return
#         end
#
#         if this_instance.respond_to?(key)
#           this_instance.send("#{key}=", this_item[key].values[0])
#         else
#           p "#{class_name} class doesn't contains attribute #{key}"
#         end
#       end
#
#       if this_instance.respond_to?('save')
#         this_instance.save
#       else
#         p "#{class_name} doesn't have save method!"
#         return
#       end
#     end
#     p "#{table_name}: Local to aws done!"
#   end
#
#   def self.backup_all_local_patient_db
#     %w(patient specimen event shipment variant variant_report).each { |table_name| backup_local_db(table_name) }
#     p 'Done!'
#   end
#
#   def self.upload_local_backups_to_aws
#     configure
#     %w(patient specimen event shipment variant variant_report).each { |table_name| local_backup_to_aws(table_name) }
#     p 'All local to aws works done!'
#   end
# end
