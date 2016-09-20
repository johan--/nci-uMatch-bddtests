require 'json'
require 'rest-client'
require_relative '../support/support'

# require_relative 'env'

class Treatment_arm_helper

  def Treatment_arm_helper.createTreatmentArmRequestJSON(version, study_id, taId, taName, description, target_id, target_name, gene, taDrugs, taStatus, stratum_id)
    drugs = taDrugs.split ','
    drugArray = []

    drugId = drugs.first == 'null' ? nil : drugs.first

    drugName = drugs.at(1).empty? ? '' : drugs.at(1)

    drugName = drugs.at(1) == 'null' ? nil : drugs.at(1)

    drugObject = {"drugId" => drugId,
                  "name" => drugName,
                  "pathway" => drugs.at(3)}
    drugArray.push(drugObject)

    taId == 'null' if taId.nil?

    taName == 'null' if taName.nil?


    # dateCreated = Helper_Methods.getDateAsRequired('current')

    @treatmentArm = {"study_id"=> study_id,
                     "id" => taId,
                     "stratum_id"=> stratum_id,
                     "name" => taName,
                     "version"=>version,
                     "description" => description,
                     "target_id" => target_id.to_i,
                     "target_name" => target_name,
                     "gene" => gene,
                     "active" => true,
                     "treatment_arm_status" => taStatus,
                     "treatment_arm_drugs" => drugArray}
    @stratum_id = stratum_id
    @treatmentArm
  end

  def Treatment_arm_helper.taVariantReport (variantReport)
    @treatmentArm.merge!(JSON.parse(variantReport))
    puts @treatmentArm.to_json
    @treatmentArm
  end

  def Treatment_arm_helper.valid_request_json
    valid_json_file = File.join(Support::TEMPLATE_FOLDER, 'validPedMATCHTreatmentArmRequestTemplate.json')
    @treatmentArm = JSON.parse(File.read(valid_json_file))
    @treatmentArm
  end

  def Treatment_arm_helper.add_drug(drugName, drugId, drugPathway = nil)
    drug_name = drugName == 'null' ? nil : drugName
    drug_id = drugId == 'null' ? nil : drugId
    @treatmentArm['treatment_arm_drugs'] << { 'drug_id' => drug_id, 'name' => drug_name, 'drug_pathway' => drugPathway}
    @treatmentArm
  end

  def Treatment_arm_helper.add_exclusion_drug(drugName, drugId)
    drug_name = drugName == 'null' ? nil : drugName
    drug_id = drugId == 'null' ? nil : drugId
    @treatmentArm['exclusion_drugs'] << {"drugId" => drug_id, "name"=> drug_name}
    @treatmentArm
  end


  def Treatment_arm_helper.findTreatmentArmsFromResponseUsingID(treatmentArmResponse, id)
    result = Array.new
    treatmentArmResponse.each do |child|
      n = child['name']
      if child['name'] == id
        result.push(child)
      end
    end
    return result
  end

  def Treatment_arm_helper.findPtenResultFromJson(treatmentArmJson, ptenIhcResult, ptenVariant, description)
    result = Array.new
    if ptenIhcResult == 'null'
      ptenIhcResult = nil
    end
    if ptenVariant == 'null'
      ptenIhcResult = nil
    end
    if description == 'null'
      ptenIhcResult = nil
    end
    treatmentArmJson['pten_results'].each do |thisPten|
      isThis = thisPten['pten_ihc_result'] == ptenIhcResult
      isThis = isThis && (thisPten['pten_variant'] == ptenVariant)
      isThis = isThis && (thisPten['description'] == description)
      if isThis
        result.push(thisPten)
      end
    end
    return result
  end

  def Treatment_arm_helper.findAssayResultFromJson(treatmentArmJson, type, gene, status, variant, loe, description)
    result = Array.new
    geneInput = gene == 'null' ? nil : gene
    type_input= type == 'null' ? nil : type
    statusInput = status == 'null' ? nil : status
    variantInput = variant == 'null' ? nil : variant
    loeInput = loe =='null' ? nil : loe
    descriptionInput = description == 'null' ? nil : description

    check_hash = {
        'gene': geneInput,
        'description': descriptionInput,
        'type': type_input,
        'assay_result_status': statusInput,
        'level_of_evidence': loeInput,
        'assay_variant': variantInput
    }
    treatmentArmJson['assay_results'].each do |thisAssay|
      result.push(thisAssay) if thisAssay == check_hash
    end
    return result
  end

  def Treatment_arm_helper.findExlusionCriteriaFromJson(treatmentArmJson, id, description)
    result = Array.new
    idInput = id=='null'?nil:id
    descriptionInput = description=='null'?nil:description

    treatmentArmJson['exclusion_criterias'].each do |thisEC|
      isThis = thisEC['id'] == idInput
      isThis = isThis && (thisEC['description'] == descriptionInput)
      if isThis
        result.push(thisEC)
      end
    end
    return result
  end

  def Treatment_arm_helper.findDrugsFromJson(treatmentArmJson, drugName, drugPathway, drugId)
    result = Array.new
    if drugName == 'null'
      drugName = nil
    end
    if drugPathway == 'null'
      drugPathway = nil
    end
    if drugId == 'null'
      drugId = nil
    end
    treatmentArmJson['treatment_arm_drugs'].each do |thisDrug|
      isThis = thisDrug['name'] == drugName
      isThis = isThis && (thisDrug['pathway'] == drugPathway)
      isThis = isThis && (thisDrug['drug_id'] == drugId)
      if isThis
        result.push(thisDrug)
      end
    end
    return result
  end

  def Treatment_arm_helper.findVariantFromJson(treatmentArmJson, variantType, variantId, variantField, variantValue)
    result = Array.new
    variant_value = case variantValue
                      when 'true' then
                        true
                      when 'false' then
                        false
                      when 'null' then
                        nil
                      else
                        variantValue
                    end

    typedValue = Treatment_arm_helper.get_long_form_of(variantType)
    thisVariantList = treatmentArmJson[typedValue]
    thisVariantList.each do |thisVariant|
      if thisVariant['identifier'] == variantId
        if thisVariant[variantField] == variant_value
          result.push(thisVariant)
        end
      end
    end
    return result
  end

  def Treatment_arm_helper.getVariantListFromJson(treatmentArmJson, variantType)
    typedValue = Treatment_arm_helper.get_long_form_of variantType
    treatmentArmJson['variant_report'][typedValue]
  end

  def self.get_long_form_of(variant)
    variant_map = {
        snv: 'single_nucleotide_variants',
        cnv: 'copy_number_variants',
        id:  'indels',
        gf:  'gene_fusions',
        nhr: 'non_hotspot_rules'
    }
    variant_map[variant.to_sym]
  end

  def Treatment_arm_helper.addPtenResult(ptenIhcResult, ptenVariant, description)
    if ptenIhcResult == 'null'
      ptenIhcResult = nil
    end
    if ptenVariant == 'null'
      ptenIhcResult = nil
    end
    if description == 'null'
      ptenIhcResult = nil
    end
    @treatmentArm['ptenResults'].push({ 'ptenIhcResult'=>ptenIhcResult, 'ptenVariant'=>ptenVariant, 'description'=>description})
    return @treatmentArm
  end

  def Treatment_arm_helper.addAssayResult(gene, type, status, variant, loe, description)
    typeInput = type == 'null' ? nil: type
    geneInput = gene == 'null' ? nil : gene
    statusInput = status=='null'?nil:status
    variantInput = variant=='null'?nil:variant
    loeInput = loe=='null'?nil:loe.to_f
    descriptionInput = description=='null'?nil:description
    @treatmentArm['assay_rules'].push(
        { 'gene'=>geneInput,
          'type' => typeInput,
          'assay_result_status'=>statusInput,
          'assay_variant'=>variantInput,
          'level_of_evidence'=>loeInput,
          'description'=>descriptionInput})
    @treatmentArm
  end

  def Treatment_arm_helper.addExclusionCriteria(id, description)
    idInput = id=='null'?nil:id
    descriptionInput = description=='null'?nil:description
    @treatmentArm['exclusionCriterias'].push({ 'id'=>idInput, 'description'=>descriptionInput})
    return @treatmentArm
  end

  def Treatment_arm_helper.addVariant(variantType, variantJson)
    va = JSON.parse(variantJson)
    @treatmentArm['variantReport'][variantType].push(va)
    @treatmentArm
  end

  def Treatment_arm_helper.templateVariant(variantAbbr)
    case variantAbbr
      when 'snv' then
        {
            'gene'=>'MTOR',
            'identifier'=>'COSM1686998',
            'protein' => 'p.Q61H',
            'level_of_evidence'=> 1.0,
            'chromosome'=>'1',
            'position'=>'11184573',
            'ocp_reference'=>'G',
            'ocp_alternative'=>'A',
            'public_med_ids'=>nil,
            'arm_specific'=>false,
            'inclusion'=>true
        }
      when 'cnv' then
        {
            'gene'=>'MYCL',
            'identifier'=>'MYCL',
            'protein' => 'p.Q61H',
            'level_of_evidence'=> 3.0,
            'chromosome'=>'1',
            'position'=>'40361592',
            'ocp_reference'=>'A',
            'ocp_alternative'=>'CNV',
            'public_med_ids'=>nil,
            'inclusion'=>true,
            'arm_specific'=>false
        }
      when 'gf' then
        {
            'gene'=>'ALK',
            'identifier'=>'TPM3-ALK.T7A20',
            'protein' => 'p.Q61H',
            'level_of_evidence'=> 2.0,
            'chromosome'=>'2',
            'position'=>'29446394',
            'ocp_reference'=>'A',
            'ocp_alternative'=>'[chr1:154142875[A',
            'public_med_ids'=>nil,
            'inclusion'=>true,
            'arm_specific'=>false
        }
      when 'id' then
        {
            'geneName'=>'DNMT3A',
            'identifier'=>'COSM99742',
            'level_of_evidence'=> 3.0,
            'chromosome'=>'2',
            'position'=>'25463297',
            'ocp_reference'=>'AAAG',
            'ocp_alternative'=>'A',
            'public_med_ids'=>nil,
            'inclusion'=>true,
            'arm_specific'=>false
        }
      when 'nhr' then
        {
            'inclusion' => true,
            'description' => 'This is an example description.',
            'public_med_ids' => [
                '18827604',
                '21917678',
                '23181703'
            ],
            'arm_specific' => false,
            'level_of_evidence' => 3.0,
            'func_gene' => 'EGFR',
            'function' => 'missense',
            'oncomine_variant_class' => 'deleterious',
            'exon' => '19'
        }
    end
  end

  def Treatment_arm_helper.findStatusDateFromJson(treatmentArmJson, statusPosition)
    logs = treatmentArmJson['status_log']
    if logs == nil
      return logs
    end
    logs.keys[statusPosition]
  end

  def Treatment_arm_helper.findStatusFromJson(treatmentArmJson, statusPosition)
    logs = treatmentArmJson['status_log']
    if logs == nil
      return logs
    end
    logs[logs.keys[statusPosition]]
  end


end

