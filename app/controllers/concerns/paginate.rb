# paginates a model result
module Paginate
  include ActiveSupport::Concern

  def paginate(params)
    if params[:page]
      model_class.page(params[:page]).per(result_length)
    else
      model_class.limit(result_length)
    end
  end

  def model_class
    controller_name.classify.constantize
  end

  def result_length
    params[:no] || 25
  end
end
