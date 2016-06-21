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
    # @treatmentArm['exclusionDrugs'].push({"drugs"=>[{"drugId"=>drugId, "name"=>drugName}]})   #use the next line instead of this one when new "exclusionDrugs" field is available
    @treatmentArm['exclusionDrugs'].push({"drugId"=>drugId, "name"=>drugName})
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

  def Treatment_arm_helper.findPlaceFromResponseUsingVersion(treatmentArmResponse, version)
    tas = JSON.parse(treatmentArmResponse)
    place = 0
    tas.each do |child|
      place += 1
      if child['version'] == version
        break
      end
    end
    return place
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
          'levelOfEvidence'=>1.0,
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
          'levelOfEvidence'=>3.0,
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
          'levelOfEvidence'=>2.0,
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
          'levelOfEvidence'=>3.0,
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
          'levelOfEvidence'=>3.0,
          'inclusion'=>true,
          'armSpecific'=>false
      }
      return result
    end
  end


end

