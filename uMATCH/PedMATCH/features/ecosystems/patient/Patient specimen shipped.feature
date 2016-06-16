#encoding: utf-8
Feature: NCH Specimen shipped messages
  Receive NCH specimen shipped messages and consume the message within MATCH


  Scenario: Received specimen_shipped message for type 'BLOOD' from NCH for a patient who has already received the specimen_received message
    Given patient "SS01" exist in "PEDMatch"
    And specimen is received for "SS01" for type "BLOOD"
    And that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS01",
        "type": "BLOOD_DNA",
        "molecular_id": "msn-SS01-B",
        "molecular_dna_id": "msn-SS01-B-D",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "specimen shipped message received and saved."

  Scenario: Received specimen_shipped message for type 'TISSUE' from NCH for a patient who has already received the specimen_received message
    Given specimen is received for "SS01" for type "TISSUE"
    And that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS01",
        "type": "TISSUE_DNA_AND_CDNA",
        "molecular_id": "msn-SS01-T",
        "molecular_dna_id": "msn-SS01-T-D",
        "molecular_cdna_id": "msn-SS01-T-C",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "specimen shipped message received and saved."

  Scenario: Received specimen_shipped message for type 'SLIDE' from NCH for a patient who has already received the specimen_received message
    Given that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS01",
        "type": "SLIDE",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "specimen shipped message received and saved."

  Scenario: Receive a specimen_shipped message from NCH for patient whose specimen_received is not yet received from NCH into MatcBox
    Given patient "SS02" exist in "PEDMatch"
    And that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS02",
        "type": "BLOOD_DNA",
        "molecular_id": "msn-SS02",
        "molecular_dna_id": "msn-SS02-D",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "No previous specimen records for patient_id (SS02) for type BLOOD_DNA."

  Scenario: Return an error message when specimen_shipped message is received for a non-existing patient
    Given that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS03",
        "type": "BLOOD_DNA",
        "molecular_id": "msn-SS03",
        "molecular_dna_id": "msn-SS03-D",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "This patient (SS03) has not been registered in MATCH.."

  Scenario: Return an error message when the molecular id is not globally unique
    Given patient "SS04" exist in "PEDMatch"
    And specimen is received for "SS04" for type "BLOOD"
    And that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS04",
        "type": "BLOOD_DNA",
        "molecular_id": "msn-SS01",
        "molecular_dna_id": "msn-SS01-D",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "specimen shipping message containing molecular id msn-SS01 is a duplicate."

  Scenario: Ensure that multiple specimen shipped messages are allowed for the same patient and surgical_event so long as the surgical_event does not have a CONFIRMED variant report
    Given patient "SS05" exist in "PEDMatch"
    And specimen is received for "SS05" for type "TISSUE"
    And specimen shipped message is received for patient "SS05", type "TISSUE_DNA_AND_CDNA", surgical_id "bsn-SS05", molecular_id "msn-SS05" with shipped date as "current"
    And specimen shipped message is received for patient "SS05", type "TISSUE_DNA_AND_CDNA", surgical_id "bsn-SS05", molecular_id "msn-SS05-1" with shipped date as "current"
    And specimen shipped message is received for patient "SS05", type "TISSUE_DNA_AND_CDNA", surgical_id "bsn-SS05", molecular_id "msn-SS05-2" with shipped date as "current"
#    And ionReporterMessage is received and consumed with "msn-SS05-2", "JOB-SS05", "sample1.bam", "gen/sample1.bam", "sample2.bam", "gen/sample2.bam" and variantReport location "gen/variants.zip" for patient "SS05" returning a message "File upload for patient (patient:SS05) completed"
#    Given the message "Saved to datastore." is received when Variant Report is confirmed for the patient psn "SS05", bsn "bsn-SS05", jobName "JOB-SS05" and variants
#	"""
#	{
#	"singleNucleotideVariants":
#    [
#	    {
#	    	"type":"snv",
#	        "confirmed" : false,
#	        "gene" : "MTOR",
#	        "exon" : "47",
#	        "geneName" : "",
#	        "chromosome" : "chr1",
#	        "position" : "11184573",
#	        "identifier" : "COSM1686998",
#	        "reference" : "G",
#	        "alternative" : "A",
#	        "readDepth" : 1625,
#	        "rare" : false,
#	        "alleleFrequency" : 0,
#	        "inclusion" : true
#	    },
#	    {
#	    	"type":"snv",
#	        "confirmed" : false,
#	        "gene" : "MTOR",
#	        "exon" : "47",
#	        "geneName" : "",
#	        "chromosome" : "chr1",
#	        "position" : "11184573",
#	        "identifier" : "COSM20417",
#	        "reference" : "G",
#	        "alternative" : "T",
#	        "readDepth" : 1625,
#	        "rare" : false,
#	        "alleleFrequency" : 0,
#	        "inclusion" : true
#	    }
#     ]
#     }
#    """
#    Then variantReport status is "CONFIRMED" for patientSequenceNumber "SS05", biopsySequenceNumber "bsn-SS05",jobName "JOB-SS05"
    And that a specimen shipped message is received from NCH:
    """
    {
      "header": {
      "msg_guid": "3037ddec-0081-4e22-8448-721ab4ad76b4",
      "msg_dttm": "2016-05-01T19:42:13+00:00"
      },
      "specimen_shipped": {
      "study_id": "APEC1621",
        "patient_id": "SS05",
        "type": "TISSUE_DNA_AND_CDNA",
        "molecular_id": "msn-SS05-3",
        "molecular_dna_id": "msn-SS05-3-D",
        "carrier": "Federal Express",
        "tracking_id": "7956 4568 1235",
        "shipped_date": "2016-05-01T19:42:13+00:00",
        "internal_use_only": {
          "stars_patient_id": "ABCXYZ",
          "stars_specimen_id_dna": "ABCXYZ-0BJ64B"
        }
      }
    }
    """
    When posted to MATCH setNucleicAcidsShippingDetails, returns a message "surgical_event_id (bsn-SS05) for patient (SS05) cannot accept this message because it has confirmed variant report."


  Scenario: When a new specimen shipped message is received after a variant report is received and in PENDING state, then the variant report should be rejected.
    Given patient "SS06" exist in "PEDMatch"
    And specimen is received for "SS06" for type "TISSUE"
    And specimen shipped message is received for patient "SS06", type "TISSUE_DNA_AND_CDNA", surgical_id "bsn-SS06", molecular_id "msn-SS06" with shipped date as "current"
#    And ionReporterMessage is received and consumed with "msn-SS06-2", "JOB-SS06", "sample1.bam", "gen/sample1.bam", "sample2.bam", "gen/sample2.bam" and variantReport location "gen/variants.zip" for patient "SS06" returning a message "File upload for patient (patient:SS06) completed"
    And specimen shipped message is received for patient "SS06", type "TISSUE_DNA_AND_CDNA", surgical_id "bsn-SS06", molecular_id "msn-SS06-1" with shipped date as "current"
#    Then variantReport status is "REJECTED" for patient_id "SS06", surgical_evewnt_id "bsn-SS06",jobName "JOB-SS06"

