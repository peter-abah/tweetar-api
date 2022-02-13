# Orders an active record relation by date
module Orderable
  def order(relation)
    sorted = relation.sort { |a, b| b.updated_at <=> a.updated_at }
    Kaminari.paginate_array sorted
  end
end