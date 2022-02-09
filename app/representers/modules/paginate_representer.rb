# module for representing paginated list of data
module PaginateRepresenter
  # returns data related to pagination
  def paginate_data
    {
      size: list.size,
      total_size: list.total_count,
      total_pages: list.total_pages,
      current_page: list.current_page
    }
  end
end
