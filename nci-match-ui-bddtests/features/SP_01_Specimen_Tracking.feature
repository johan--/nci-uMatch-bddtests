Feature: Specimen Tracking page
  User can access and track the specimens

  Background:
    Given I am a logged in user
    When I navigate to the specimen-tracking page

  @ui_p2
  Scenario: User can track Specimens
    Then I see the Shipping Location section
    And I see the Trend Analysis section
    And I can see the chart at index "0" is for "MDA"
    And I can see the chart at index "1" is for "MoCha"
    And I can see the Distribution of specimens between sites
    And I can see the Shipment Table Heading
    And I can see the Shipments table
    And I can see the Shipment table headers
    When I collect information about shipment
    And I enter "molecular_id" from response at index "0" in the search field
    Then I can compare the details about shipment against the API

    @ui_p2 @fling
    Scenario: All Specimens assigned to a patient shows up on the tracking table
      When I enter "PT_CR05_SpecimenShippedTwice" in the search field for tracking table
      And I collect information about shipment
      Then I expect to see "2" rows in the tracking table
      And I expect to see "2" rows with patient id of "PT_CR05_SpecimenShippedTwice" for the specimens
      And I expect to see "2" rows with surgical ids of "PT_CR05_SpecimenShippedTwice_SEI1" for both specimens
      And I expect to see Molecular Ids of "PT_CR05_SpecimenShippedTwice_MOI1,PT_CR05_SpecimenShippedTwice_MOI2" in the table.
