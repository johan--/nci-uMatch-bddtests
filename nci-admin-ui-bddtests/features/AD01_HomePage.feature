@admin_ui_p1 @home
Feature: Home page for the admin tool

Scenario: Home01 - A logged in user can access the various sections of the homepage
Given I am a logged in user
Then I can see the dashboard
And I can see the top level menu buttons
And I can see that the upload section is active
And I can see the TA upload section
And I logout

Scenario: Home02 - Certain buttons and input fields are activated only when a file is being uploaded
Given I am a logged in user
When I navigate to "Uploader" page
Then I see that the "Upload a file" button is "enabled"
And I see that the "Upload File" button is "disabled"
And I see that the "Confirm upload to Treatment Arm" button is "disabled"
And I logout

