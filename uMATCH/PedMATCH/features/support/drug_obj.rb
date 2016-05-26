
class Drug_obj
  attr_accessor :pathway
  attr_accessor :drugId
  attr_accessor :drugName

  def initialize(drugString)
    drugs = drugString.split ','

    if drugs.at(0).empty?
      @drugId = ''
    elsif drugs.at(0) == 'null'
      @drugId = nil
    else
      @drugId = drugs.at(0)
    end

    if drugs.at(1).empty?
      @drugName = ''
    elsif drugs.at(1) == 'null'
      @drugName = nil
    else
      @drugName = drugs.at(1)
    end

    if drugs.at(3).empty?
      @pathway = ''
    end
    if drugs.at(3) == 'null'
      @pathway = nil
    else
      @pathway = drugs.at(3)
    end
  end

end