Feature: Upload Treatment Arm from File
As an Admin user
I can upload an excel file to Admin tool 
So that I can view the enclosed treatment arms in the file for upload to TA ecosystem

Scenario: Uploading a valid treatment arm to admin tool should add it to the pending TA table
Given I am a user of type "admin"
When I upload file "file_name.xlsx"
Then I "should" see a success message
And I "should" see the treatment arm in the pending treatment arm table

Scenario: Upload an invalid treatment arm table should raise an error and not complete the upload
Given I am a user of type "admin"
When I upload file "file_name.xlsx"
Then I "should not" see a success message
And I "should not" see the treatment arm in the pending treatment arm table

