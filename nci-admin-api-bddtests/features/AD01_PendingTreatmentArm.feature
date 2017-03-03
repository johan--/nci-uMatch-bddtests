Feature: Pending treatment arm call
As an Admin user
I want to access the pending treamtment arm api endpoint
So I can get a json response to feed the UI

Background: 
Given I am a user of type "admin"

Scenario: A valid user can get a list of pending treatment arms
When I issue a get request to pending treatment arms
Then I should get a list of all the treatment arm in the table

Scenario: A valid user can retrieve the details of a single treatment arm from the pending ta table
When I issue a get request to pending treatment arms with id "" and stratum id ""
Then I should get "1" treatment arm from the table
And The "id" of the treatment arm should be ""
And The "stratum_id" of the treatment arm should be ""
