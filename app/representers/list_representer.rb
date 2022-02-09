require_relative './modules/paginate_representer'

# A base class to represent an active record relation with pagination
class ListRepresenter
  include PaginateRepresenter

  attr_reader :list, :options, :extra_data

  def initialize(list, options = {}, extra_data = {})
    @list = list
    @options = options
    @extra_data = extra_data
  end

  def as_json
    list_json.merge paginate_data
  end

  def list_json
    {
      list: list.map { |data| Representer.new(data, options, extra_data).as_json }
    }
  end
end
