@patients_get
Feature: Patient GET service valid special case tests

  Scenario: PT_SC01 statistics service should have correct result
    Given patient GET service name "statistics"
    When GET from MATCH patient API, http code "200" should return
    Then patient statistics field "number_of_patients" should have correct value
    Then patient statistics field "number_of_patients_on_treatment_arm" should have correct value
    Then patient statistics field "number_of_patients_with_confirmed_variant_report" should have correct value
    Then patient statistics field "treatment_arm_accrual" should have correct value
# /api/v1/patients/statistics(.:format)
# /api/v1/patients/pending_items(.:format)
# /api/v1/patients/amois(.:format)

# /api/v1/patients/patient_limbos(.:format)

# /api/v1/patients/:patient_id/action_items(.:format)
# /api/v1/patients/:patient_id/treatment_arm_history(.:format)
# /api/v1/patients/:patient_id/specimen_events(.:format)