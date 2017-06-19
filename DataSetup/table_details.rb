class TableDetails

  TREATMENT_ARM = {
      name: 'treatment_arm',
      keys: %w(treatment_arm_id date_created)
  }

  TREATMENT_ARM_ASSIGNMENT_EVENT = {
      name: 'treatment_arm_assignment_event',
      keys: %w(treatment_arm_id_stratum_id assignment_date)
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

  MESSAGE = {
      name: 'message',
      keys: %w(id)
  }

  VARIANT = {
      name: 'variant',
      keys: %w(uuid)
  }

  VARIANT_REPORT = {
      name: 'variant_report',
      keys: %w(patient_id variant_report_received_date)
  }

  ION_REPORTERS_APEC1621SC = {
      name: 'ion_reporters_APEC1621SC',
      keys: %w(ion_reporter_id)
  }

  ION_REPORTERS_EAY131 = {
      name: 'ion_reporters_EAY131',
      keys: %w(ion_reporter_id)
  }

  SAMPLE_CONTROLS = {
      name: 'sample_controls',
      keys: %w(molecular_id)
  }

  TREATMENT_ARM_PENDING = {
    name: 'treatment_arm_pending',
    keys: %w(treatment_arm_id version)
  }

  def self.primary_key(table)
    raise "#{table} is not a valid Ped-Match table" unless all_tables.include?(table)
    const_get(table.upcase)[:keys][0]
  end

  def self.sorting_key(table)
    raise "#{table} is not a valid Ped-Match table" unless all_tables.include?(table)
    keys = const_get(table.upcase)[:keys]
    if keys.size>1
      keys[1]
    else
      puts "#{table} doesn't has sorting key, empty string returned"
      ''
    end
  end

  def self.treatment_arm_tables
    %w(treatment_arm treatment_arm_assignment_event treatment_arm_pending)
  end

  def self.patient_tables
    %w(patient assignment event shipment specimen variant variant_report message)
  end

  def self.ion_tables
    %w(ion_reporters_APEC1621SC ion_reporters_EAY131 sample_controls)
  end

  def self.all_tables
    (self.patient_tables << self.treatment_arm_tables << self.ion_tables).flatten
  end

end