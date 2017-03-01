@admin_ui_p2
Feature: This feature lets the user edit a treatment arm 

Scenario: A user can edit a treatment arm
Given I am a logged in user
And I go to the "Editor" section
And I click on Treamtment Arm "XYZ" version "123" in the list
Then I can see that "XYZ" shows up in the Selected Treatment Arm
And I can see that "123" shows up in the Version
And I can see the details of the Treatment Arm in the Editor panel
When I Change something in the Editor tab
Then I should see that change in the Changes made section

Scenario: A user can validate the changes made to a treatment arm
Given I am a logged in user
And I go to the "Editor" section
And I click on Treamtment Arm "XYZ" version "123" in the list
And I Change something in the Editor tab to something else
Then I should see that change in the Changes made section
When I can click on "Validate Changes" button
Then I should see the list of validation issues


