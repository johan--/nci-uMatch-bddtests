Feature: Specimen Tracking page
  User can access and track the specimens

  @ui @broken
  Scenario:
    Given I am a logged in user
    When I navigate to the Specimen Tracking page
    Then I see the Shipping Location section
    And I can see the Pie chart with the same distribution
    And I can see the Specimen tracking table
    And I can compare the details about shipment against the API