require 'json'
require 'rest-client'
require_relative 'env'

class Treatment_arm_helper

  def Treatment_arm_helper.createTreatmentArmRequestJSON(version, study_id, taId, taName, description, targetId, targetName, gene, taDrugs, taStatus)
    drugs = taDrugs.split ','
    drugArray = []
    # drugObject = Hash.new
    if drugs.at(0) == 'null'
      drugId = nil
    else
      drugId = drugs.at(0)
    end

    if drugs.at(1).empty?
      drugName = ''
    else
      drugName = drugs.at(1)
    end

    if drugs.at(1) == 'null'
      drugName = nil
    else
      drugName = drugs.at(1)
    end

    drugObject = {"drugId" => drugId,
                  "name" => drugName,
                  "pathway" => drugs.at(3)}
    drugArray.push(drugObject)

    if taId == 'null'
      taId = nil
    end

    if taName == 'null'
      taName = nil
    end


    @treatmentArm = {"study_id"=> study_id,
                     "id" => taId,
                     "name" => taName,
                     "version"=>version,
                     "description" => description,
                     "targetId" => targetId,
                     "targetName" => targetName,
                     "gene" => gene,
                     "treatmentArmStatus" => taStatus,
                     "treatmentArmDrugs" => drugArray}
    return @treatmentArm
  end

  def Treatment_arm_helper.taVariantReport (variantReport)
    @treatmentArm["variantReport"] = JSON.parse(variantReport)
    return @treatmentArm
  end

  def Treatment_arm_helper.validRquestJson()
    @treatmentArm = JSON(IO.read('./features/support/validPedMATCHTreatmentArmRequestTemplate.json'))
    return @treatmentArm
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
    @treatmentArm['exclusionDrugs'].push({"drugs"=>[{"drugId"=>drugId, "name"=>drugName}]})   #use the next line instead of this one when new "exclusionDrugs" field is available
    # @treatmentArm['exclusionDrugs'].push({"drugId"=>drugId, "name"=>drugName})
    return @treatmentArm
  end

  def Treatment_arm_helper.findResultsFromResponseUsingVersion(treatmentArmResponse, version)
    result = Array.new
    tas = JSON.parse(treatmentArmResponse)
    tas.each do |child|
      if child['version'] == version
        result.push(child)
      end
    end
    return result
  end

  def Treatment_arm_helper.findPtenResultFromJson(treatmentArmJson, ptenIhcResult, ptenVariant, description)
    result = Array.new
    treatmentArmJson['pten_results'].each do |thisPten|
      isThis = thisPten['pten_ihc_result'] == ptenIhcResult
      isThis = isThis && thisPten['pten_variant'] == ptenVariant
      isThis = isThis && thisPten['description'] == description
      if isThis
        result.push(thisPten)
      end
    end
    return result
  end

  def Treatment_arm_helper.findDrugsFromJson(treatmentArmJson, drugName, drugPathway, drugId)
    result = Array.new
    treatmentArmJson['treatment_arm_drugs'].each do |thisDrug|
      isThis = thisDrug['name'] == drugName
      isThis = isThis && thisDrug['pathway'] == drugPathway
      isThis = isThis && thisDrug['drug_id'] == drugId
      if isThis
        result.push(thisDrug)
      end
    end
    return result
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
    @treatmentArm['ptenResults'].push({ "ptenIhcResult"=>ptenIhcResult, "ptenVariant"=>ptenVariant, "description"=>description})
    return @treatmentArm
  end

  def Treatment_arm_helper.addVariant(variantType, variantJson)
    va = JSON.parse(variantJson)
    @treatmentArm['variantReport'][variantType].push(va)
    return @treatmentArm
  end


end