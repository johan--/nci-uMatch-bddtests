Feature: Signing in feature


Scenario: Login with valid credentials allows user to access protected pages
    Given I am on the login page
    # Then I should see the login button
    When I login with "valid" email and password
    # Then I should see the home page