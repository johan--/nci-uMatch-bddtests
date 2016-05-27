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
    @treatmentArm = JSON(IO.read('./features/support/validTreatmentArmRequestTemplate.json'))
    return @treatmentArm
  end
end