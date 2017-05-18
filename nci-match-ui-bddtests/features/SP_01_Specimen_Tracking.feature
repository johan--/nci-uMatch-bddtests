Feature: Specimen Tracking page
  User can access and track the specimens

  Background:
    Given I stay logged in as "read_only" user
    When I navigate to the specimen-tracking page

  @ui_p2
  @demo_p3
  Scenario: User can see and navigate to Specimens, CLIA Lab and Slide Shipment tabs
    Then I can see Specimens, CLIA Lab and Slide Shipment tabs
    When I click on "Specimens" tab
    Then the "Specimens" tab becomes active
    When I click on "CLIA Lab Shipments" tab
    Then the "CLIA Lab Shipments" tab becomes active
    When I click on "Slide Shipments" tab
    Then the "Slide Shipments" tab becomes active

  @ui_p2
  Scenario: Specimens assigned to a patient show up on the tracking table
    When I enter "PT_CR05_SpecimenShippedTwice" as Patient Id in the search field for tracking table
    And I click on the surgical event in the row "1"
    Then I verify that I am taken directly to "PT_CR05_SpecimenShippedTwice_SEI1" page
    And I verify that surgical event tab is active
    Then I expect to see "2" rows in the tracking table

  @ui_p2
  Scenario: User can track Specimens
    When I click on "Specimens" tab
    And I collect information on specimens used for shipments
    Then I can see the "Specimens" table columns
    And I see the total number displayed matches with the response length
    When I search for "PT_SC04d_TwoAssay" in the search field
    Then I see that the row matches with specimens data of the backend for "PT_SC04d_TwoAssay"
    When I search for "PT_SS25_BloodShipped" in the search field
    Then I see that the row matches with specimens data of the backend for "PT_SS25_BloodShipped"

  @ui_p2
  Scenario: User can track Specimens
    When I collect information on shipment used for shipments
    And I sort and separate the slide from tissue
    When I click on "CLIA Lab Shipments" tab
    Then I can see the "CLIA Lab Shipments" table columns
    And I see the total number displayed matches with the response length for "DNA"
    When I search for "PT_SC02i_PendingApproval" in the search field
    Then I see that the row matches with Clia Lab data of the backend for "PT_SC02i_PendingApproval"
    When I click on "Slide Shipments" tab
    And I can see the "Slide Shipments" table columns
    And I see the total number displayed matches with the response length for "SLIDE"
    When I search for "PT_SC04m_PendingApproval" in the search field
    Then I see that the row matches with Slides data of the backend for "PT_SC04m_PendingApproval"
