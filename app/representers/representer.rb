require_relative './modules/representer_finder'

# A wrapper for calling json representers
class Representer
  include Modules::RepresenterFinder

  attr_reader :data, :options, :extra_data

  def initialize(data, options = {}, extra_data = {})
    @data = data
    @options = options
    @extra_data = extra_data
  end

  def as_json
    representer.as_json.merge
  end
end
