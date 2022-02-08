# A base class to represent a model as json
class DataRepresenter
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def as_json
    data.as_json.merge(extra_data)
  end

  private

  def extra_data
    {}
  end
end
