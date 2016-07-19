What is uMatch-patient-loader:
uMatch-patient-loader is a tool that helps us generate patient data in LOCAL environment for testing purpose.
To create a patient, we create an event message queue in json format and push it to the loader, the loader will call local API to load all of the messages in turn
Notice: this loader only works in LOCAL environment, when we generate all test data using this loader, we can export these data from local dynamodb and import them to aws

How to use it:
1. Make sure run bundle install in nci-uMatch-bddtests root folder
2. Design a patient with reasonable time line (patien_id: testID)
3. Create a json file in patients folder with name testID.json
4. Put massages for every step of the patient time line in testID.json file, from older to newer
5a. Run command line: ruby -r "./patient_loader.rb" -e "PatientLoader.load_patient 'testID'"
5b. Or open RubyMine, open patient_loader.rb put this call in the bottom of this file: PatientLoader.load_patient('testID'), then run