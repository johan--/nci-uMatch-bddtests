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