# A base class to represent a model as json
class DataRepresenter
  attr_reader :model, :options

  def initialize(model, options, extra_data)
    @model = model
    @options = options
    @user = extra_data[:user]
  end

  def as_json
    model.as_json(options).merge(extra_data)
  end

  def extra_data
    model.associations_for_json.reduce({}) do |result, method|
      association = model.send(method)
      result[method] = Representer.new(association, options, { user: @user }).as_json if association
      result
    end
  end
end
