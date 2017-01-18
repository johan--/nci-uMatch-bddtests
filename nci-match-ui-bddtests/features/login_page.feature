##
# Created by raseel.mohamed on 6/3/16
##

Feature: Login
  A user should be able to login only with valid credentials.
  @ui_p2
  Scenario: Accessing a protected page redirects to login page.
    Given I am on the login page
    When I navigate to the patients page
    Then I am redirected back to the login page

  @ui_p2
  Scenario: Login with invalid credentials asks the user to login again.
    Given I am on the login page
    When I login with invalid email and password
    Then I should be asked to enter the credentials again

  @ui_p1 @demo_p1
  Scenario: Login with proper credentials grants access protected pages.
    Given I am a logged in user
    When I navigate to the patients page
    Then I should be able to the see "Patients" page
