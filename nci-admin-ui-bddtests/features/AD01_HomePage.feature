Feature: Home page for the admin tool 

Scenario: A logged in user can access the various sections of the homepage. 
Given I am a logged in user
Then I can see the dashboard
And I can see the top level menu buttons
And I can see that the upload section is active
And I can see the TA upload section

