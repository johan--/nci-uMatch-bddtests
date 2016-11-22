Before:
Please put these two lines to you local ~/.bashrc file and source it:
export AWS_SECRET_ACCESS_KEY=<replace_this_with_your_secret_key>
export AWS_ACCESS_KEY_ID=<replace_this_with_your_access_key>

Class usage:
DynamoDb-- this class helps clear the related dynamodb tables
    1. Clear aws dynamodb tables using command line:
        cd DataSetup
        ./dynamo_delete_script.rb -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -e 'https://dynamodb.us-east-1.amazonaws.com' -r us-east-1
    2. Clear local dynamodb tables using command line:
        cd DataSetup
        ./dynamo_delete_script.rb -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -e 'http://localhost:8000' -r localhost
    3. Clear local dynamodb tables in other class
        require_relative 'dynamo_delete_script'
        DynamoDb.new('local').clear_all_tables


PatientMessageLoader-- this class helps load message queue to patient api to create patient data locally
    1. Create a json file(for example, test.json) in the folder: local_patient_data
    2. In the file make an array, append patient messages one by one (in correct order)
    3. require_relative 'patient_message_loader'
    4. PatientMessageLoader.load_patient_to_local('test', 15.0)
        the first parameter is the file name (don't include extension name)
        the second parameter is the waiting time you want the loader wait before it post the next message (to give patient processor time to process), it is recommended to use value that is greater than 15





DynamoDataUploader-- this class helps upload backup data from local dynamodb to local json file, and from local json file to related aws dynamodb tables
    A: From local dynamodb to local json files, files will be created under folder: seed_data_for_upload
        require_relative 'dynamo_data_upload'
        DynamoDataUploader.backup_all_local_db

    B: From local json files to related aws dynamodb tables:
        1. Upload to aws dynamodb tables using command line:
            cd DataSetup
            ./dynamo_data_upload.rb -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -e 'https://dynamodb.us-east-1.amazonaws.com' -r us-east-1
        2. Upload to local dynamodb tables using command line:
            cd DataSetup
            ./dynamo_data_upload.rb -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY -e 'http://localhost:8000' -r localhost
        3. Upload to local dynamodb tables in other class
            require_relative 'dynamo_data_upload'
            DynamoDataUploader.new('local').upload_patient_data_to_aws


How to work append seed data to current existing seed data lib:
1. Clear all local data:
    DynamoDb.new('local').clear_all_tables
2. Load all existing seed data
    DynamoDataUploader.new('local').upload_treatment_arm_to_aws
    DynamoDataUploader.new('local').upload_patient_data_to_aws
    DynamoDataUploader.new('local').upload_ion_to_aws
3. Generate new seed data
4. Backup all data from current local dynamodb:
    DynamoDataUploader.backup_all_local_db
5. Check in seed_data_for_upload/{patient related table).json files to git


Other tips
1. Start with a fresh new full loaded local dynamodb:
DynamoDb.new('local').clear_all_tables
DynamoDataUploader.new('local').upload_treatment_arm_to_aws
DynamoDataUploader.new('local').upload_patient_data_to_aws
DynamoDataUploader.new('local').upload_ion_to_aws

2. Start with an empty local dynamodb;
DynamoDb.new('local').clear_all_tables

3. Replace all patient seed data
    a.  DynamoDb.new('local').clear_all_patient_tables
    b.  Do whatever change in the local_patient_data/*.rb file and run the file
        repeat step a and b until the changes in step b is satisfied
    c.  load all OTHER "_data_done.rb" like:
        load 'local_patient_data/Patient_01A_data_done.rb'
        load 'local_patient_data/Patient_02A_data_done.rb'
        load 'local_patient_data/Patient_03A_data_done.rb'
        load 'local_patient_data/Patient_04A_data_done.rb'
        load 'local_patient_data/Patient_05A_data_done.rb'
        load 'local_patient_data/Patient_06A_data_done.rb'
        load 'local_patient_data/Patient_07A_data_done.rb'
        load 'local_patient_data/Patient_TA_UI_data_done.rb'
        #load other files if necessary
    d.  DynamoDataUploader.backup_all_patient_local_db
    e.  Check in seed_data_for_upload/{patient related table).json files to git

4. Remove one patient seed data
DynamoDataUploader.delete_all_data_for_patient(:patient_id)


