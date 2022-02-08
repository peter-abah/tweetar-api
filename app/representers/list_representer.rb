# A base class to represent an active record relation with pagination
class ListRepresenter
  include PaginateRepresenter

  attr_reader :list

  def initialize(list)
    @list = list
  end

  def as_json
    { list: list_json }.merge(paginate_data(list))
  end

  def list_json
    list.map do |data|
      DataRepresenter.new(data).as_json
    end
  end
end
