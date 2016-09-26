class TableDetails

  TREATMENT_ARM = {
      name: 'treatment_arm',
      keys: %w(id date_created)
  }

  TREATMENT_ARM_ASSIGNMENT_EVENT = {
      name: 'treatment_arm_assignment_event',
      keys: %w(patient_id date_created)
  }

  PATIENT = {
      name: 'patient',
      keys: %w(patient_id registration_date)
  }

  ASSIGNMENT = {
      name: 'assignment',
      keys: %w(patient_id assignment_date)
  }

  EVENT = {
      name: 'event',
      keys: %w(entity_id event_date)
  }

  SHIPMENT = {
      name: 'shipment',
      keys: %w(uuid shipped_date)
  }

  SPECIMEN = {
      name: 'specimen',
      keys: %w(patient_id sorting_key)
  }

  VARIANT = {
      name: 'variant',
      keys: %w(uuid)
  }

  VARIANT_REPORT = {
      name: 'variant_report',
      keys: %w(patient_id variant_report_received_date)
  }

  def self.treatment_arm_tables
    %w(treatment_arm treatment_arm_assignment_event)
  end

  def self.patient_tables
    %w(patient assignment event shipment specimen variant variant_report)
  end

  def self.all_tables
    (self.patient_tables << self.treatment_arm_tables).flatten
  end

end