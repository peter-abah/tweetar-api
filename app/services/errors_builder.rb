class ErrorsBuilder
  attr_reader :model

  def initialize(model)
    @model = model
  end

  def errors
    build_errors
  end

  def build_errors
    model.errors.reduce(Hash.new([])) do |res, error|
      res[error.attribute] = [*res[error.attribute], error.full_message]
      res
    end
  end
end
