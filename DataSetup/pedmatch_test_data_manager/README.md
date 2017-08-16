###Before:
Please put these two lines to you local ~/.bashrc file and source it:
```
export AWS_SECRET_ACCESS_KEY=<replace_this_with_your_secret_key>
export AWS_ACCESS_KEY_ID=<replace_this_with_your_access_key>
```

##Ped-Match BDD tests seed data introduction:
For Ped-Match BDD tests, we have different set of seed data (including patients, treatment arms and sample controls) for different test tags, the tags are: patients, ion_reporter, treatment_arm, ui, admin_api, admin_ui
For every tag, we have a folder for it. In that folder we store dynamodb dump file for every table.
Every time a new BDD travis build is triggered, there is a line of script to clear dynamodb tables and reload seed data using the folder name which is stored in variable $CUC_TAG_TRIM

For patient seed data preparation, there are two steps:

    1. Create a patient story and store it
    2. Create patient seed data by loading stored patient story

There are mutliple reasons that why we use this way to create patient seed data instead of post message one by one in the realtime.

    1. Patient data structure may change. But the patient story will never change. We need to reload a patient when the data structure changes
    2. The template message may change. So we store template message separately. When we reload a patient, from patient story we always find the latest message template



This README will introduce how to create seed data and how to reload it.

####========= Classes =========
* **Constants**: store all constants, including all api urls, all secrets(only environment varaible names, you need to setup your own ENV) for different test tiers
* **Logger**: a small log utility. Try to use this logger everywhere
* **PatientStory**: create, query, modify, save, load patient stories
* **PatientStorySender**: Process patient story with message template to generate actual REST calls and execute those call to generate patient seed data
* **patient_messages.json**: store all necessary information when create patient REST call, include payload template, http method, before and after operations
* **PedMatchDatabase**: Tool to manipulate local and INT database, including clear database, load dump file to database, take snapshot for from local dynamodb to dump file
* **PedMatchRestClient**: REST calls sender
* **SeedFile**: Tool to process dynamodb dump file (seed file). Including clear, copy patients between tags, delete patients
* **TableInfo**: Tool to provide information for all PedMatch related dynamodb tables
* **table_details.json**: store all information for PedMatch related dynamodb tables, updated this json if any dynamodb information changes
* **TreatmentArmSender**: create treatment arm seed data
* **Utilities**: other utilities
* **PedMatchTestData**: The hub class that use above class to do combined work, For example, related a patient need delete that patient from seed file, then clear local database then related the processed seed file then re-send that patient story then take snapshot for local dynaomdb


####========= Usages =========

1. How to create new tag and load initial data (treatment arms and sample controls)
   or just re-initial (clear all seed patients) for an existing tag

    ```ruby
    PedMatchTestData.clear_and_initial_all(tag_name)   # this method will create the tag folder if the tag is totally new
    ```

2. How to copy some existing good patient seed data from tag to tag (normally when you initial a new tag, you want some existing patients)
    ```ruby
    list = [patient_id1, patient_id2,...]
    SeedFile.copy_patients_between_tags(list, 'patients', tag_name)  ##patients tag have almost all seed patients

    ```

3. How to create a new patient
    ```ruby

    pt = PatientStory.new(patient_id)
    pt.create_seed_patient{
      pt.story_register
      pt.story_specimen_received_tissue
      ...
    }
    PedMatchTestData.load_seed_patients([patient_id], tag_name)
    ```

4. How to re-generate existing patients
    ```ruby
    list = [patient_id1, patient_id2,...]
    PedMatchTestData.load_seed_patients(list, tag_name)
    ```
    **ATTENTION**: After the patients generating work done (new patient or re-generate), please check the output log, make sure all patients get generated successfully
           If there is any patient listed in the failed list, please regenerate those patients

5. How to reload seed data to dynamodb
    ```ruby
    PedMatchDatabase.reload_local(tag_name)  ## to local
    PedMatchDatabase.reload_int(tag_name)  ## to int
    ```

6. I don't want to do seed data related work, I just want to create a patient temporarily without breaking the seed dump file
    ```ruby
    pt = PatientStory.new(patient_id)
    pt.create_temporary_patient{
      pt.story_register
      pt.story_specimen_received_tissue
      ...
    }
    PedMatchTestData.send_a_patient_story(pt)
    ```
    or
    ```ruby
    pt = PatientStory.new(patient_id)
    pt.story_register
    pt.story_specimen_received_tissue
    ...
    PedMatchTestData.send_a_patient_story(pt)
    ```

7. How to added a new treatment arm
    ```ruby
    ta = {'treatment_arm_id'=>'APEC1621SC-TEST', 'stratum_id'=>'100', 'version'=>'v_1', ...} #a hash
    PedMatchTestData.add_treatment_arm(ta)
    ```

    or
    ```ruby
    ta = "{"treatment_arm_id":"APEC1621SC-TEST", "stratum_id":"100", "version":"v_1", ...}" #a string
    PedMatchTestData.add_treatment_arm(ta)
    ```
