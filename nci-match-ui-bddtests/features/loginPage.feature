##
# Created by raseel.mohamed on 6/3/16
##

Feature: Login
  In order to check proper authentication
  As a user
  I should be able to login only with valid credentials.

  @login
  Scenario: Try to Access a protected page should redirect to login page.
    Given I am on the login page
    When I navigate to the patients page
    Then I am redirected back to the login page

  @login
  Scenario: Login with invalid credentials asks the user to login again.
    Given I am on the login page
    When I login with invalid email and password
    Then I should be asked to enter the credentials again

  @login
  Scenario: Login with proper credentials should let you access protected pages.
    Given I am on the login page
    When  I login with valid email and password
    Then I should be able to the see Dashboard page
