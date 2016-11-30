@patients_get
Feature: Patient GET service tests (false results)


######### PT_GF_NI Services without id /api/v1/patients/service(.:format)
  Scenario Outline: PT_GF_NI01. Invalid projections should be ignored
    Examples:

  Scenario Outline: PT_GF_NI02. Service should return 404 and empty result if no resource match query parameters
    Examples:

######### PT_GF_WI Services with id /api/v1/patients/service/:id(.:format)
  Scenario Outline: PT_GF_WI01. Service should return 404 and empty result if provided id has no this type of resource
    Examples:

  Scenario Outline: PT_GF_WI02. Service should return 404 and empty result if provided id doesn't exist
    Examples:

  Scenario Outline: PT_GF_WI03. Invalid projections should be ignored
    Examples:

  Scenario Outline: PT_GF_WI04. Service should return 404 and empty result if no resource match query parameters
    Examples:

######### PT_GF_WP Services with patient_id /api/v1/patients/:patient_id/service(.:format)
  Scenario Outline: PT_GF_WP01. Service should return 404 and empty result if patient_id has no this type of resource
    Examples:

  Scenario Outline: PT_GF_WP02. Service should return 404 and empty result if patient_id doesn't exist
    Examples:

  Scenario Outline: PT_GF_WP03. Invalid projections should be ignored
    Examples:

  Scenario Outline: PT_GF_WP04. Service should return 200 and array if no resource match query parameters
    Examples:

######### PT_GF_PI Services with patient_id and id /api/v1/patients/:patient_id/service/:id(.:format)
  Scenario Outline: PT_GF_PI01. Service should return 404 and empty result if patient_id has no this type of resource
    Examples:

  Scenario Outline: PT_GF_PI02. Service should return 404 and empty result if patient_id doesn't exist
    Examples:

  Scenario Outline: PT_GF_PI03. Service should return 404 and empty result if id has no this type of resource
    Examples:

  Scenario Outline: PT_GF_PI04. Service should return 404 and empty result if id doesn't exist
    Examples:

  Scenario Outline: PT_GF_PI05. Invalid projections should be ignored
    Examples:

  Scenario Outline: PT_GF_PI06. Service should return 200 and empty array if no resource match query parameters
    Examples:

