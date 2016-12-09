
Feature: Feature for end-to-end test demo

Background: wait for process to complete
  Then wait for "15" seconds
#  @demo
  Scenario: Load APEC1621-A arm
    Given that treatment arm is received from COG:
	"""
    {
      "active": null,
      "treatment_arm_id": "APEC1621-A",
      "name": "APEC1621-A",
      "date_created": "2016-06-24T15:38:31+00:00",
      "version": "2015-08-06",
      "stratum_id": "100",
      "description": "TEST Treatment Arm used by Cucumber Tests",
      "target_id": "113",
      "target_name": "Crizotinib",
      "gene": "ALK",
      "treatment_arm_status": "OPEN",
      "study_id": "APEC1621",
      "assay_results": [],
      "num_patients_assigned": null,
      "date_opened": null,
      "treatment_arm_drugs": [{
        "name": "Crizotinib",
        "pathway": "ALK",
        "drug_id": "113"
      }],
      "variant_report": {
        "snv_indels": [],
        "non_hotspot_rules": [{
          "inclusion": true,
          "oncomine_variant_class": "deleterious",
          "public_med_ids": null,
          "func_gene": "PTEN",
          "arm_specific": "false",
          "level_of_evidence": "3.0",
          "function": null,
          "protein_match": null,
          "type": "nhr",
          "exon": null
        }],
        "copy_number_variants": [
        {
          "variant_type" : "cnv",
          "ref_copy_number": 2.0,
          "raw_copy_number": 8.8,
          "copy_number": 8.8,
          "confidence_interval_95percent": 1.94266,
          "confidence_interval_5percent": 1.67303,
          "confirmed": false,
          "chromosome": "chr10",
          "position": "89624207",
          "identifier": "PTEN",
          "ocp_reference": "T",
          "ocp_alternative": "<CNV>",
          "rare": false,
          "level_of_evidence": 2.0,
          "inclusion": true,
          "armSpecific": false,
          "type": "cnv"
        }],
        "gene_fusions": [{
          "variant_type" : "fusion",
          "ocp_reference": "A",
          "func_gene": "ALK",
          "identifier": "TPM3-ALK.T7A20",
          "inclusion": true,
          "public_med_ids": ["23724913"],
          "arm_specific": "false",
          "level_of_evidence": "2.0",
          "chromosome": "2.0",
          "ocp_alternative": "[chr1:154142875[A",
          "description": "ALK translocation",
          "position": "29446394",
          "type": "gf"
        }, {
          "variant_type" : "fusion",
          "ocp_reference": "C",
          "func_gene": "FGFR2",
          "identifier": "FGFR2-OFD1.F17O3",
          "inclusion": true,
          "public_med_ids": null,
          "arm_specific": "false",
          "level_of_evidence": "3.0",
          "chromosome": "10.0",
          "ocp_alternative": "C[chrX:13754596[",
          "description": "some description",
          "position": "123243211",
          "type": "gf"
        }]
      },
      "exclusion_diseases": [{
        "disease_code": "10058354",
        "ctep_sub_category": null,
        "short_name": "Bronchioloalveolar carcinoma",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "10025032",
        "ctep_sub_category": null,
        "short_name": "Lung adenocarcinoma",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "90600324",
        "ctep_sub_category": null,
        "short_name": "Lung adenocar. w/ bronch. feat.",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "10029514",
        "ctep_sub_category": null,
        "short_name": "Non-small cell lung cancer, NOS",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "10025125",
        "ctep_sub_category": null,
        "short_name": "Squamous cell lung carcinoma",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }],
      "inclusion_diseases": [{
        "disease_code": "10033701",
        "ctep_sub_category": null,
        "short_name": "Papillary thyroid carcinoma",
        "ctep_category": "Thyroid Cancer"
      }],
      "exclusion_drugs": [{
        "name": "Doxorubicin Hydrochloride",
        "drug_id": "10001",
        "drug_class": "ALK inhibitor",
        "target": "ALK"
      }]
    }
	"""
    When creating a new treatment arm using post request
    Then a message with Status "Success" and message "Saved to datastore." is returned:

  Scenario: Load APEC1621-B arm
    Given that treatment arm is received from COG:
    """
{
      "active": null,
      "treatment_arm_id": "APEC1621-B",
      "name": "APEC1621-B",
      "date_created": "2016-06-24T15:38:31+00:00",
      "version": "2015-08-06",
      "stratum_id": "100",
      "description": "TEST Treatment Arm used by Cucumber Tests",
      "target_id": "113",
      "target_name": "Crizotinib",
      "gene": "ALK",
      "treatment_arm_status": "OPEN",
      "study_id": "APEC1621",
      "assay_results": [
        {
            "func_gene" : "PTEN",
            "assayResultStatus" : "POSITIVE",
            "assayVariant" : "PRESENT",
            "level_of_evidence" : 3.0
        },
        {
            "func_gene" : "MLH1",
            "assayResultStatus" : "POSITIVE",
            "assayVariant" : "EMPTY",
            "level_of_evidence" : 5.0
        }
      ],
      "num_patients_assigned": null,
      "date_opened": null,
      "treatment_arm_drugs": [{
        "name": "Crizotinib",
        "pathway": "ALK",
        "drug_id": "113"
      }],
      "variant_report": {
        "snv_indels": [{
          "variant_type" : "snp",
          "confirmed": false,
          "chromosome": "chr6",
          "position": "152419923",
          "identifier": "COSM1074639",
          "ocp_reference": "A",
          "ocp_alternative": "C",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": true,
          "armSpecific": false
        }, {
          "variant_type": "snp",
          "confirmed": false,
          "chromosome": "chr9",
          "position": "80412493",
          "identifier": "COSM52975",
          "ocp_reference": "C",
          "ocp_alternative": "T",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": true,
          "armSpecific": false
        }, {
          "variant_type": "snp",
          "confirmed": false,
          "chromosome": "chr17",
          "position": "7577064",
          "identifier": "COSM44451",
          "ocp_reference": "T",
          "ocp_alternative": "C",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": false,
          "armSpecific": false
        }, {
          "variant_type": "snp",
          "confirmed": false,
          "chromosome": "chrX",
          "position": "70349258",
          "identifier": "COSM757681",
          "ocp_reference": "C",
          "ocp_alternative": "G",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": false,
          "armSpecific": false
        }, {
          "variant_type": "snp",
          "confirmed": false,
          "chromosome": "chrX",
          "position": "100611165",
          "identifier": "BT9",
          "ocp_reference": "A",
          "ocp_alternative": "T",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": true,
          "armSpecific": false
        }, {
          "variant_type": "del",
          "type": "id",
          "confirmed": false,
          "chromosome": "chr22",
          "position": "30035190",
          "identifier": "COSM22189",
          "ocp_reference": "TTC",
          "ocp_alternative": "-",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": true
        }, {
          "variant_type": "del",
          "type": "id",
          "confirmed": false,
          "chromosome": "chrX",
          "position": "70339250",
          "identifier": "COSM131612",
          "ocp_reference": "CAAGGTTTCAATAACCAG",
          "ocp_alternative": "-",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": true
        }, {
          "variant_type": "del",
          "type": "id",
          "confirmed": false,
          "chromosome": "chrX",
          "position": "70339270",
          "identifier": "COSM143738",
          "ocp_reference": "TGCTGTCTCTGGGGA",
          "ocp_alternative": "-",
          "rare": false,
          "level_of_evidence": 3.0,
          "inclusion": false
        }],
        "non_hotspot_rules": [{
          "func_gene": "MYCL",
          "oncomine_variant_class": "amplification",
          "rare": false,
          "level_of_evidence": 2.3,
          "inclusion": true,
          "type": "nhr"
        }, {
          "func_gene": "TP53",
          "function": "Refallele",
          "rare": false,
          "level_of_evidence": 3.2,
          "inclusion": false,
          "armSpecific": false,
          "type": "nhr"
        }],
        "copy_number_variants": [{
          "variant_type": "cnv",
          "ref_copy_number": 2.0,
          "raw_copy_number": 7.7,
          "copy_number": 7.7,
          "confidence_interval_95percent": 1.81291,
          "confidence_interval_5percent": 1.59412,
          "confirmed": false,
          "chromosome": "chr1",
          "position": "40361592",
          "identifier": "MYCL",
          "ocp_reference": "C",
          "ocp_alternative": "<CNV>",
          "rare": false,
          "level_of_evidence": 2.0,
          "inclusion": true,
          "armSpecific": false,
          "type": "cnv"
        }, {
          "variant_type": "cnv",
          "ref_copy_number": 2.0,
          "raw_copy_number": 8.2,
          "copy_number": 8.2,
          "confidence_interval_95percent": 4.36137,
          "confidence_interval_5percent": 4.04279,
          "confirmed": false,
          "chromosome": "chr1",
          "position": "147022100",
          "identifier": "BCL9",
          "ocp_reference": "G",
          "ocp_alternative": "<CNV>",
          "rare": false,
          "level_of_evidence": 2.0,
          "inclusion": false,
          "armSpecific": false,
          "type": "cnv"
        }, {
          "variant_type": "cnv",
          "ref_copy_number": 2.0,
          "raw_copy_number": 8.8,
          "copy_number": 8.8,
          "confidence_interval_95percent": 1.94266,
          "confidence_interval_5percent": 1.67303,
          "confirmed": false,
          "chromosome": "chr10",
          "position": "89624207",
          "identifier": "PTEN",
          "ocp_reference": "T",
          "ocp_alternative": "<CNV>",
          "rare": false,
          "level_of_evidence": 2.0,
          "inclusion": true,
          "armSpecific": false,
          "type": "cnv"
        }],
        "gene_fusions": [{
          "variant_type": "fusion",
          "ocp_reference": "C",
          "func_gene": "TPM3",
          "identifier": "TPM3-NTRK1.T7N10.COSF1318_1",
          "inclusion": true,
          "public_med_ids": null,
          "level_of_evidence": "2.0",
          "chromosome": "chr2",
          "ocp_alternative": "C[chr1:156844362[",
          "position": "154142875",
          "type": "gf"
        },
        {
          "variant_type": "fusion",
          "ocp_reference": "G",
          "func_gene": "NTRK1",
          "identifier": "TPM3-NTRK1.T7N10.COSF1318_2",
          "inclusion": true,
          "public_med_ids": null,
          "level_of_evidence": "3.0",
          "chromosome": "chr2",
          "ocp_alternative": "[chr1:154142875[G",
          "position": "156844362",
          "type": "gf"
        },
        {
          "variant_type": "fusion",
          "ocp_reference": "T",
          "func_gene": "TPM3",
          "identifier": "TPM3-ROS1.T7R35.COSF1273_1",
          "inclusion": false,
          "public_med_ids": null,
          "level_of_evidence": "3.0",
          "chromosome": "chr1",
          "ocp_alternative": "T]chr6:117642559]",
          "position": "154142877",
          "type": "gf"
        },
        {
          "variant_type": "fusion",
          "ocp_reference": "T",
          "func_gene": "ROS1",
          "identifier": "TPM3-ROS1.T7R35.COSF1273_2",
          "inclusion": false,
          "public_med_ids": null,
          "level_of_evidence": "3.0",
          "chromosome": "chr6",
          "ocp_alternative": "[chr1:154142877[T",
          "position": "117642559",
          "type": "gf"
        }
        ]
      },
      "exclusion_diseases": [{
        "disease_code": "10058354",
        "ctep_sub_category": null,
        "short_name": "Bronchioloalveolar carcinoma",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "10025032",
        "ctep_sub_category": null,
        "short_name": "Lung adenocarcinoma",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "90600324",
        "ctep_sub_category": null,
        "short_name": "Lung adenocar. w/ bronch. feat.",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "10029514",
        "ctep_sub_category": null,
        "short_name": "Non-small cell lung cancer, NOS",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }, {
        "disease_code": "10025125",
        "ctep_sub_category": null,
        "short_name": "Squamous cell lung carcinoma",
        "ctep_category": "Non-Small Cell Lung Cancer"
      }],
      "inclusion_diseases": [{
        "disease_code": "10033701",
        "ctep_sub_category": null,
        "short_name": "Papillary thyroid carcinoma",
        "ctep_category": "Thyroid Cancer"
      }],
      "exclusion_drugs": [{
        "name": "Doxorubicin Hydrochloride",
        "drug_id": "10001",
        "drug_class": "ALK inhibitor",
        "target": "ALK"
      }]
    }
    """
    When creating a new treatment arm using post request
    Then a message with Status "Success" and message "Saved to datastore." is returned:

  Scenario: Check treatment arm status is OPEN
    Then the treatmentArmStatus field has a value "OPEN" for the ta "APEC1621-A"
    Then the treatmentArmStatus field has a value "OPEN" for the ta "APEC1621-B"

#  @demo
  Scenario Outline: Patient in registration
    Given that Patient StudyID "<StudyId>" PatientSeqNumber "<patient_id>" StepNumber "<step_number>" PatientStatus "<patient_status>" Message "Patient registration trigger" with "<date_created>" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "Message has been processed successfully" is returned with a "Success"
  Examples:
    |StudyId      |patient_id           |step_number        |patient_status       |date_created       |
    |APEC1621     |00001                |1.0                |REGISTRATION         |current            |
    |APEC1621     |00002                |1.0                |REGISTRATION         |current            |
    |APEC1621     |00003                |1.0                |REGISTRATION         |current            |
    |APEC1621     |00004                |1.0                |REGISTRATION         |current            |
    |APEC1621     |00005                |1.0                |REGISTRATION         |current            |

  Scenario Outline: Patient's Blood specimen is received
    Given template specimen received message in type: "BLOOD" for patient: "<patient_id>", it has surgical_event_id: ""
    Then set patient message field: "collection_dt" to value: "current"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
    |patient_id       |
    |00001            |
    |00002            |
    |00003            |
    |00004            |
    |00005            |

  Scenario Outline: Patient's Tissue specimen is received
    Given template specimen received message in type: "TISSUE" for patient: "<patient_id>", it has surgical_event_id: "<surgical_event_id>"
    Then set patient message field: "collection_dt" to value: "current"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
    |patient_id         |surgical_event_id      |
    |00001              |00001-Tissue_Specimen_1|
    |00002              |00002-Tissue_Specimen_1|
    |00003              |00003-Tissue_Specimen_1|
    |00004              |00004-Tissue_Specimen_1|
    |00005              |00005-Tissue_Specimen_1|


#scenario failing because the application code is expecting surgical_event_id for Blood shipment, but Blood does not have an associated surgical_event _id
  Scenario Outline: Patient's Blood specimen shipment is received
    Given template specimen shipped message in type: "BLOOD" for patient: "<patient_id>", it has surgical_event_id: "", molecular_id or slide_barcode: "<molecular_id>"
    Then set patient message field: "molecular_id" to value: "<molecular_id>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
    |patient_id       |molecular_id     |
    |00001            |00001-00013      |
    |00002            |00002-00013      |
    |00003            |00003-00013      |
    |00004            |00004-00013      |
    |00005            |00005-00013      |


  Scenario Outline: Patient's Tissue specimen shipment is received
    Given template specimen shipped message in type: "TISSUE" for patient: "<patient_id>", it has surgical_event_id: "<surgical_event_id>", molecular_id or slide_barcode: "<molecular_id>"
    Then set patient message field: "surgical_event_id" to value: "<surgical_event_id>"
    Then set patient message field: "molecular_id" to value: "<molecular_id>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
    |patient_id         |surgical_event_id      |molecular_id     |
    |00001              |00001-Tissue_Specimen_1|00001-00012      |
    |00002              |00002-Tissue_Specimen_1|00002-00012      |
    |00003              |00003-Tissue_Specimen_1|00003-00012      |
    |00004              |00004-Tissue_Specimen_1|00004-00012      |
    |00005              |00005-Tissue_Specimengit m_1|00005-00012      |

  Scenario Outline: Patient's SLIDE specimen shipment is received
    Given template specimen shipped message in type: "SLIDE" for patient: "<patient_id>", it has surgical_event_id: "<surgical_event_id>", molecular_id or slide_barcode: "<slide_barcode>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
    |patient_id         |surgical_event_id      |slide_barcode                    |
    |00001              |00001-Tissue_Specimen_1|00001_Slide_barcode_1            |
    |00002              |00002-Tissue_Specimen_1|00002_Slide_barcode_1            |
    |00003              |00003-Tissue_Specimen_1|00003_Slide_barcode_1            |
    |00004              |00004-Tissue_Specimen_1|00004_Slide_barcode_1            |
    |00005              |00005-Tissue_Specimen_1|00005_Slide_barcode_1            |

  Scenario Outline: Patient's ICCPTENs assay message is received
    Given template assay message with surgical_event_id: "<surgical_event_id>" for patient: "<patient_id>"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "result" to value: "NEGATIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      |patient_id         |surgical_event_id      |
      |00001              |00001-Tissue_Specimen_1|
      |00002              |00002-Tissue_Specimen_1|
      |00003              |00003-Tissue_Specimen_1|
      |00004              |00004-Tissue_Specimen_1|
      |00005              |00005-Tissue_Specimen_1|


  Scenario Outline: Patient's ICCMLH1s assay message is received
    Given template assay message with surgical_event_id: "<surgical_event_id>" for patient: "<patient_id>"
    Then set patient message field: "biomarker" to value: "ICCMLH1s"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "result" to value: "NEGATIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
  |patient_id         |surgical_event_id      |
  |00001              |00001-Tissue_Specimen_1|
  |00002              |00002-Tissue_Specimen_1|
  |00003              |00003-Tissue_Specimen_1|
  |00004              |00004-Tissue_Specimen_1|
  |00005              |00005-Tissue_Specimen_1|

  Scenario Outline: Patient's pathology report confirmation is received
    Given template pathology report with surgical_event_id: "<surgical_event_id>" for patient: "<patient_id>"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      |patient_id         |surgical_event_id      |
      |00001              |00001-Tissue_Specimen_1|
      |00002              |00002-Tissue_Specimen_1|
      |00003              |00003-Tissue_Specimen_1|
      |00004              |00004-Tissue_Specimen_1|
      |00005              |00005-Tissue_Specimen_1|

  Scenario Outline: Patient's Tissue variant report is uploaded to MatchBox
    Given template variant file uploaded message for patient: "<patient_id>", it has molecular_id: "<molecular_id>" and analysis_id: "<analysis_id>" and need files in S3 Y or N: "Y"
    Then set patient message field: "s3_bucket_name" to value: "<bucket>"
    Then set patient message field: "tsv_file_path_name" to value: "<tsv>"
    Then set patient message field: "vcf_file_path_name" to value: "<vcf>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
  Examples:
    |patient_id     |molecular_id       |analysis_id          |bucket                                               |tsv                |vcf                |
    |00001          |00001-00012        |ANI_00001-00012      |bdd-test-data/demo/00001/00001-00012/ANI_00001-00012 |00001.tsv          |00001.vcf          |
    |00002          |00002-00012        |ANI_00002-00012      |bdd-test-data/demo/00002/00002-00012/ANI_00002-00012 |00002.tsv          |00002.vcf          |
    |00003          |00003-00012        |ANI_00003-00012      |bdd-test-data/demo/00003/00003-00012/ANI_00003-00012 |00003.tsv          |00003.vcf          |
    |00004          |00004-00012        |ANI_00004-00012      |bdd-test-data/demo/00004/00004-00012/ANI_00004-00012 |00004.tsv          |00004.vcf          |
    |00005          |00005-00012        |ANI_00005-00012      |bdd-test-data/demo/00005/00005-00012/ANI_00005-00012 |00005.tsv          |00005.vcf          |



  Scenario Outline: Patient's Blood variant report is uploaded to MatchBox
    Given template variant file uploaded message for patient: "<patient_id>", it has molecular_id: "<molecular_id>" and analysis_id: "<analysis_id>" and need files in S3 Y or N: "Y"
    Then set patient message field: "s3_bucket_name" to value: "<bucket>"
    Then set patient message field: "tsv_file_path_name" to value: "<tsv>"
    Then set patient message field: "vcf_file_path_name" to value: "<vcf>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      |patient_id     |molecular_id       |analysis_id          |bucket                                               |tsv                |vcf                |
      |00001          |00001-00013        |ANI_00001-00013      |bdd-test-data/demo/00001/00001-00012/ANI_00001-00012 |00001.tsv          |00001.vcf          |
      |00002          |00002-00013        |ANI_00002-00013      |bdd-test-data/demo/00002/00002-00012/ANI_00002-00012 |00002.tsv          |00002.vcf          |
      |00003          |00003-00013        |ANI_00003-00013      |bdd-test-data/demo/00003/00003-00012/ANI_00003-00012 |00003.tsv          |00003.vcf          |
      |00004          |00004-00013        |ANI_00004-00013      |bdd-test-data/demo/00004/00004-00012/ANI_00004-00012 |00004.tsv          |00004.vcf          |
      |00005          |00005-00013        |ANI_00005-00013      |bdd-test-data/demo/00005/00005-00012/ANI_00005-00012 |00005.tsv          |00005.vcf          |

#  Scenario: Patient's Blood variant report is confirmed
#    Given template variant report confirm message for patient: "00001", it has molecular_id: "00001-00013", analysis_id: "ANI_00001-00013" and status: "CONFIRMED"
#    When POST to MATCH patients service, response includes "successfully" with code "202"
#
#  Scenario: Patient's Tissue variant report is confirmed
#    Given template variant report confirm message for patient: "00001", it has molecular_id: "00001-00012", analysis_id: "ANI_00001-00012" and status: "CONFIRMED"
#    When POST to MATCH patients service, response includes "successfully" with code "202"
#
#
#  Scenario: Patient's Assignment report is confirmed
#    Given template assignment report confirm message for patient: "00001", it has molecular_id: "00001-00012", analysis_id: "ANI_00001-00012" and status: "CONFIRMED"
#    When POST to MATCH patients service, response includes "successfully" with code "202"

