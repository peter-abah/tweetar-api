# module for representing paginated list of data
module PaginateRepresenter
  # returns data related to pagination
  def paginate_data(data)
    {
      size: data.size,
      total_size: data.total_count,
      total_pages: data.total_pages,
      current_page: data.current_page
    }
  end
end
