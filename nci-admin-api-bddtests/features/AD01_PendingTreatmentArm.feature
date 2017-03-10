Feature: Pending treatment arm call
As an Admin user
I want to access the pending treamtment arm api endpoint
So I can get a json response to feed the UI

Background: 
Given I am a user of type "ADMIN"

Scenario: A valid user can get a list of pending treatment arms
When I issue a get request to pending treatment arms
Then I should get a list of all the treatment arm in the table

Scenario: A valid user can retrieve the details of a single treatment arm from the pending ta table
When I issue a get request to pending treatment arms with id "APEC1621-PEND_A" and version "5_2_2017-20_57_22"
And The "treatment_arm_id" of the treatment arm should be "APEC1621-PEND_A"
And The "version" of the treatment arm should be "5_2_2017-20_57_22"
