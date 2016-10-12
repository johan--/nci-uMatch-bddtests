Feature: Specimen Tracking page
  User can access and track the specimens

  @ui @fling
  Scenario: User can track Specimens
    Given I am a logged in user
    When I navigate to the specimen-tracking page
    Then I see the Shipping Location section
    And I see the Trend Analysis section
    And I can see the chart at index "0" is for "MDA"
    And I can see the chart at index "1" is for "MoCha"
    And I can see the Distribution of specimens between sites
    And I can see the Shipments table
    And I can see the Shipment table headers
    When I collect information about shipment
    And I enter "molecular_id" from response at index "0" in the search field
    Then I can compare the details about shipment against the API


#  Scenario: Clicking on the document displays the document below the table - MATCHKB-363