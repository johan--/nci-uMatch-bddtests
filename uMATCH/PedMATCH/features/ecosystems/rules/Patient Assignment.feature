@rules
Feature: Ensure the rules are fired correctly and patients are assigned to the right treatment arm

  Scenario: Add a new treatment arm to Matchbox
    Given that treatment arm is received from COG:
    """
    {
      "name": "Rules-Test1",
      "id": "Rules-Test1",
      "version": "2015-08-06",
      "description": "This TA is used by Cuke Test",
      "target_id": "113",
      "target_name": "Crizotinib",
      "gene": "ALK",
      "treatment_arm_status": "OPEN",
      "study_id": "APEC1621",
      "stratum_id": "100",
      "assay_results": [],
      "num_patients_assigned": null,
      "date_created": "2016-06-24T15:38:31+00:00",
      "date_opened": null,
      "treatment_arm_drugs": [{
          "pathway": "ALK",
          "drug_id": "113",
          "name": "Crizotinib"
      }],
      "variant_report": {
          "indels": [],
          "copy_number_variants": [],
          "single_nucleotide_variants": [],
          "non_hotspot_rules": [{
              "gene": "PTEN",
              "oncominevariantclass": "deleterious",
              "level_of_evidence": "3.0",
              "protein_match": null,
              "type": "nhr",
              "public_med_ids": null,
              "arm_specific": "false",
              "inclusion": true,
              "exon": null,
              "function": null
          }],
          "gene_fusions": [{
              "position": "29446394",
              "level_of_evidence": "2.0",
              "description": "ALK translocation",
              "alternative": "[chr1:154142875[A",
              "gene_name": "ALK",
              "type": "gf",
              "chromosome": "2.0",
              "identifier": "TPM3-ALK.T7A20",
              "public_med_ids": ["23724913"],
              "arm_specific": "false",
              "reference": "A",
              "inclusion": true
          }, {
              "position": "123243211",
              "level_of_evidence": "3.0",
              "description": "some description",
              "alternative": "C[chrX:13754596[",
              "gene_name": "FGFR2",
              "type": "gf",
              "chromosome": "10.0",
              "identifier": "FGFR2-OFD1.F17O3",
              "public_med_ids": null,
              "arm_specific": "false",
              "reference": "C",
              "inclusion": true
          }]
      },
      "exclusion_diseases": [{
          "medra_code": "10058354",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Bronchioloalveolar carcinoma"
      }, {
          "medra_code": "10025032",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Lung adenocarcinoma"
      }, {
          "medra_code": "90600324",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Lung adenocar. w/ bronch. feat."
      }, {
          "medra_code": "10029514",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Non-small cell lung cancer, NOS"
      }, {
          "medra_code": "10025125",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Squamous cell lung carcinoma"
      }],
      "inclusion_diseases": [{
          "medra_code": "10033701",
          "ctep_sub_category": null,
          "ctep_category": "Thyroid Cancer",
          "short_name": "Papillary thyroid carcinoma"
      }],
      "exclusion_drugs": [{
          "drug_class": "ALK inhibitor",
          "target": "ALK",
          "drug_id": "10001",
          "name": "Doxorubicin Hydrochloride"
      }]
    }
    """
    When posted to MATCH newTreatmentArm
    Then a message with Status "SUCCESS" and message "Saved to datastore." is returned:
    Then the treatmentArmStatus field has a value "OPEN" for the ta "Rules-Test1"


  Scenario: Matching inclusion gene fusion variant and inclusion disease - Assign to TA
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    When posted to the AssignPatient service
    Then a patient assignment json is returned with patient_assignment_status "AVAILABLE"

  Scenario: Matching inclusion gene fusion variant but does not match inclusion disease - Do not assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_and_not_inclusion_disease"
    When posted to the AssignPatient service
    Then a patient assignment json is returned with patient_assignment_status "NO_ARM_ASSIGNED"

  Scenario: Matching inclusion disease but does not match inclusion variant - Do not assign
    Given  the patient assignment json "patient_json_with_non_matching_inclusion_variant_matching_inclusion_disease"
    When posted to the AssignPatient service
    Then a patient assignment json is returned with patient_assignment_status "NO_ARM_ASSIGNED"


  Scenario: Add a new treatment arm to Matchbox
    Given that treatment arm is received from COG:
    """
    {
      "name": "Rules-Test2",
      "id": "Rules-Test2",
      "version": "2015-08-06",
      "description": "This TA is used by Cuke Test",
      "target_id": "113",
      "target_name": "Crizotinib",
      "gene": "ALK",
      "treatment_arm_status": "OPEN",
      "study_id": "APEC1621",
      "stratum_id": "100",
      "assay_results": [],
      "num_patients_assigned": null,
      "date_created": "2016-06-24T15:38:31+00:00",
      "date_opened": null,
      "treatment_arm_drugs": [{
          "pathway": "ALK",
          "drug_id": "113",
          "name": "Crizotinib"
      }],
      "variant_report": {
          "indels": [],
          "copy_number_variants": [],
          "single_nucleotide_variants": [],
          "non_hotspot_rules": [{
              "gene": "PTEN",
              "oncominevariantclass": "deleterious",
              "level_of_evidence": "3.0",
              "protein_match": null,
              "type": "nhr",
              "public_med_ids": null,
              "arm_specific": "false",
              "inclusion": true,
              "exon": null,
              "function": null
          }],
          "gene_fusions": [{
              "position": "29446394",
              "level_of_evidence": "2.0",
              "description": "ALK translocation",
              "alternative": "[chr1:154142875[A",
              "gene_name": "ALK",
              "type": "gf",
              "chromosome": "2.0",
              "identifier": "TPM3-ALK.T7A20",
              "public_med_ids": ["23724913"],
              "arm_specific": "false",
              "reference": "A",
              "inclusion": false
          }, {
              "position": "123243211",
              "level_of_evidence": "3.0",
              "description": "some description",
              "alternative": "C[chrX:13754596[",
              "gene_name": "FGFR2",
              "type": "gf",
              "chromosome": "10.0",
              "identifier": "FGFR2-OFD1.F17O3",
              "public_med_ids": null,
              "arm_specific": "false",
              "reference": "C",
              "inclusion": false
          }]
      },
      "exclusion_diseases": [{
          "medra_code": "10058354",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Bronchioloalveolar carcinoma"
      }, {
          "medra_code": "10025032",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Lung adenocarcinoma"
      }, {
          "medra_code": "90600324",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Lung adenocar. w/ bronch. feat."
      }, {
          "medra_code": "10029514",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Non-small cell lung cancer, NOS"
      }, {
          "medra_code": "10025125",
          "ctep_sub_category": null,
          "ctep_category": "Non-Small Cell Lung Cancer",
          "short_name": "Squamous cell lung carcinoma"
      }],
      "inclusion_diseases": [{
          "medra_code": "10033701",
          "ctep_sub_category": null,
          "ctep_category": "Thyroid Cancer",
          "short_name": "Papillary thyroid carcinoma"
      }],
      "exclusion_drugs": [{
          "drug_class": "ALK inhibitor",
          "target": "ALK",
          "drug_id": "10001",
          "name": "Doxorubicin Hydrochloride"
      }]
    }
    """
    When posted to MATCH newTreatmentArm
    Then a message with Status "SUCCESS" and message "Saved to datastore." is returned:
    Then the treatmentArmStatus field has a value "OPEN" for the ta "Rules-Test2"


  Scenario: Matching exclusion variant - Don't assign to TA
    Given  the patient assignment json "patient_json_with_matching_exclusion_variant_inclusion_disease"
    When posted to the AssignPatient service
    Then a patient assignment json is returned with patient_assignment_status "NO_ARM_ASSIGNED"

#  Scenario: Matching non-hotspot rule - oncomine variant class
#
#  Scenario: Matching non-hotspot rule - function
#
#  Scenario: Matching non-hotspot rule - gene and exon
#
#  Scenario: Matching exclusion disease
#
#  Scenario: Matching exclusion drugs
#
#  Scenario: Compasionate care (Patient eligible to be assigned by the treatment arm is closed


