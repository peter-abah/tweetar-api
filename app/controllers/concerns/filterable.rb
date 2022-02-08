# Filters an active record relation if a query is present in params
module Filterable
  def filter(relation)
    query = params[:q]
    query ? relation.filter_by_query(query) : relation
  end
end