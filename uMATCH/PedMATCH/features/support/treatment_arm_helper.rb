require 'json'
require 'rest-client'
require_relative '../support/support'

# require_relative 'env'

class Treatment_arm_helper

  def Treatment_arm_helper.createTreatmentArmRequestJSON(version, study_id, taId, taName, description, targetId, targetName, gene, taDrugs, taStatus, stratum_id)
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
                     "target_id" => targetId.to_i,
                     "target_name" => targetName,
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

  def Treatment_arm_helper.validRquestJson()
    valid_json_file = File.join(Support::TEMPLATE_FOLDER, 'validPedMATCHTreatmentArmRequestTemplate.json')
    @treatmentArm = JSON.parse(File.read(valid_json_file))
    @treatmentArm
  end

  def Treatment_arm_helper.addDrug(drugName, drugPathway, drugId)
    if drugName == 'null'
      drugName = nil
    end
    if drugPathway == 'null'
      drugPathway = nil
    end
    if drugId == 'null'
      drugId = nil
    end
    @treatmentArm['treatmentArmDrugs'].push({"drugId"=>drugId, "name"=>drugName, "pathway"=>drugPathway})
    return @treatmentArm
  end

  def Treatment_arm_helper.addPedMATCHExclusionDrug(drugName, drugId)
    if drugName == 'null'
      drugName = nil
    end
    if drugId == 'null'
      drugId = nil
    end
    # @treatmentArm['exclusion_drugs'].push({"drugs"=>[{"drugId"=>drugId, "name"=>drugName}]})   #use the next line instead of this one when new "exclusion_drugs" field is available
    @treatmentArm['exclusion_drugs'].push({"drugId"=>drugId, "name"=>drugName})
    return @treatmentArm
  end

  # def Treatment_arm_helper.findResultsFromResponseUsingVersion(treatmentArmResponse, version)
  #   result = Array.new
  #   tas = JSON.parse(treatmentArmResponse)
  #   tas.each do |child|
  #     if child['version'] == version
  #       result.push(child)
  #     end
  #   end
  #   return result
  # end
  #
  # def Treatment_arm_helper.findPlaceFromResponseUsingVersion(treatmentArmResponse, version)
  #   tas = JSON.parse(treatmentArmResponse)
  #   place = 0
  #   tas.each do |child|
  #     place += 1
  #     if child['version'] == version
  #       break
  #     end
  #   end
  #   return place
  # end

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

  def Treatment_arm_helper.findAssayResultFromJson(treatmentArmJson, gene, status, variant, loe, description)
    result = Array.new
    geneInput = gene=='null'?nil:gene
    statusInput = status=='null'?nil:status
    variantInput = variant=='null'?nil:variant
    loeInput = loe=='null'?nil:loe
    descriptionInput = description=='null'?nil:description

    treatmentArmJson['assay_results'].each do |thisAssay|
      isThis = thisAssay['gene'] == geneInput
      isThis = isThis && (thisAssay['assay_variant'] == variantInput)
      isThis = isThis && (thisAssay['description'] == descriptionInput)
      isThis = isThis && (thisAssay['assay_result_status'] == statusInput)
      isThis = isThis && (thisAssay['level_of_evidence'] == loeInput)
      if isThis
        result.push(thisAssay)
      end
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
    if variantValue == 'null'
      variantValue = nil
    end
    typedValue = case variantType
                   when 'snv' then
                     'single_nucleotide_variants'
                   when 'id' then
                     'indels'
                   when 'gf' then
                     'gene_fusions'
                   when 'cnv' then
                     'copy_number_variants'
                   when 'nhr' then
                     'non_hotspot_rules'
                 end
    thisVariantList = treatmentArmJson['variant_report'][typedValue]
    thisVariantList.each do |thisVariant|
      if thisVariant['identifier'] == variantId
        if thisVariant[variantField] == variantValue
          result.push(thisVariant)
        end
      end
    end
    return result
  end

  def Treatment_arm_helper.getVariantListFromJson(treatmentArmJson, variantType)
    result = Array.new

    typedValue = case variantType
                   when 'snv' then
                     'single_nucleotide_variants'
                   when 'id' then
                     'indels'
                   when 'gf' then
                     'gene_fusions'
                   when 'cnv' then
                     'copy_number_variants'
                   when 'nhr' then
                     'non_hotspot_rules'
                 end
    return treatmentArmJson['variant_report'][typedValue]
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

  def Treatment_arm_helper.addAssayResult(gene, status, variant, loe, description)
    geneInput = gene=='null'?nil:gene
    statusInput = status=='null'?nil:status
    variantInput = variant=='null'?nil:variant
    loeInput = loe=='null'?nil:loe.to_f
    descriptionInput = description=='null'?nil:description
    @treatmentArm['assayResults'].push({ 'gene'=>geneInput, 'assayResultStatus'=>statusInput, 'assayVariant'=>variantInput, 'level_of_evidence'=>loeInput, 'description'=>descriptionInput})
    return @treatmentArm
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
    return @treatmentArm
  end

  def Treatment_arm_helper.templateVariant(variantAbbr)
    if variantAbbr == 'snv'
      result = {
          'type'=>'snv',
          'confirmed'=> false,
          'publicMedIds'=>nil,
          'geneName'=>'MTOR',
          'chromosome'=>'1',
          'position'=>'11184573',
          'identifier'=>'COSM1686998',
          'reference'=>'G',
          'alternative'=>'A',
          'description' =>'some description',
          'rare'=>false,
          'level_of_evidence'=>1.0,
          'inclusion'=>true,
          'armSpecific'=>false
      }
      return result
    end
    if variantAbbr == 'cnv'
      result = {
          'type'=>'cnv',
          'refCopyNumber'=>0.0,
          'rawCopyNumber'=>0.0,
          'copyNumber'=>0.0,
          'confidenceInterval95percent'=>0.0,
          'confidenceInterval5percent'=>0.0,
          'confirmed'=> false,
          'publicMedIds'=>nil,
          'geneName'=>'MYCL',
          'chromosome'=>'1',
          'position'=>'40361592',
          'identifier'=>'MYCL',
          'reference'=>'A',
          'alternative'=>'<CNV>',
          'description' =>'MYCL transiocation',
          'rare'=>false,
          'level_of_evidence'=>3.0,
          'inclusion'=>true,
          'armSpecific'=>false
      }
      return result
    end
    if variantAbbr == 'gf'
      result = {
          'type'=>'gf',
          'confirmed'=> false,
          'publicMedIds'=>nil,
          'geneName'=>'ALK',
          'chromosome'=>'2',
          'position'=>'29446394',
          'identifier'=>'TPM3-ALK.T7A20',
          'reference'=>'A',
          'alternative'=>'[chr1:154142875[A',
          'description' =>'ALK translocation',
          'rare'=>false,
          'level_of_evidence'=>2.0,
          'inclusion'=>true,
          'armSpecific'=>false
      }
      return result
    end
    if variantAbbr == 'id'
      result = {
          'type'=>'cnv',
          'confirmed'=> false,
          'publicMedIds'=>nil,
          'geneName'=>'DNMT3A',
          'chromosome'=>'2',
          'position'=>'25463297',
          'identifier'=>'COSM99742',
          'reference'=>'AAAG',
          'alternative'=>'A',
          'description' =>'some description',
          'rare'=>false,
          'level_of_evidence'=>3.0,
          'inclusion'=>true,
          'armSpecific'=>false
      }
      return result
    end
    if variantAbbr == 'nhr'
      result = {
          'type'=>'nhr',
          'gene'=>'EGFR',
          'exon'=>'19',
          'oncominevariantclass'=>'deleterious',
          'identifier'=>'COSM99742',
          'function'=>'nonframeshiftInsertion',
          'publicMedIds'=>nil,
          'rare'=>false,
          'level_of_evidence'=>3.0,
          'inclusion'=>true,
          'armSpecific'=>false
      }
      return result
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

