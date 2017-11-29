
Feature: Getting a list of all the Auth0 Users

Scenario: Pending_01: A valid user can get a list of all the Auth0 Users
    Given I am a user of type "ADMIN"
    When I issue a get request to auth0_information
    Then I should get a list of all the Auth0 users
