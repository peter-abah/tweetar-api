# Filters an active record relation if a query is present in params
module Filterable
  def filter(relation)
    methods.reduce(relation) { |filtered, m| m.call(filtered) }
  end

  def filter_query(relation)
    query = params[:q]
    query ? relation.filter_by_query(query) : relation
  end

  def filter_user(relation)
    user_id = params[:user_id]
    user_id ? relation.where(user_id: user_id) : relation
  end

  def filter_parent(relation)
    parent_id = params[:parent_id]
    parent_id ? relation.where(parent_id: parent_id) : relation
  end

  def methods
    [
      method(:filter_user),
      method(:filter_parent),
      method(:filter_query)
    ]
  end
end
