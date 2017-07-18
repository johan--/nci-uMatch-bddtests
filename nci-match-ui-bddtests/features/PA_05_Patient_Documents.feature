Feature: Patient Document Tab

  Scenario: User can see the documents attached to the patient
    Given I clear the file "vcf_sample.zip", from S3 under patient "PT_AM05_TsVrReceived1"
    And I am a logged in user
    When I go to patient "PT_AM05_TsVrReceived1" details page
    When I click on the Documents tab
    And I "cannot" see the file "vcf_file.zip" on S3 under "PT_AM05_TsVrReceived1"
    And I "cannot" see the file "vcf_file.zip" in the Documents tab
    And I click Upload button to add a file "vcf_file.zip"
    Then I "can" see the file "vcf_file.zip" in the Documents tab
    And I "can" see the file "vcf_file.zip" on S3 under "PT_AM05_TsVrReceived1"
