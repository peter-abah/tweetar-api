# Filters an active record relation if a query is present in params
module Filterable
  def filter(relation)
    filter_query filter_user(relation)
  end

  def filter_query(relation)
    query = params[:q]
    query ? relation.filter_by_query(query) : relation
  end

  def filter_user(relation)
    user_id = params[:user_id]
    user_id ? relation.where(user_id: user_id) : relation
  end
end
