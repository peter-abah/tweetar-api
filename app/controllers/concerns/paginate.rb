# paginates a model result
module Paginate
  include ActiveSupport::Concern

  def paginate(collection)
    if params[:page]
      collection.page(params[:page]).per(result_length)
    else
      collection.limit(result_length)
    end
  end

  def result_length
    params[:no] || 25
  end
end
