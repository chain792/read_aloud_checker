module Api::Kaminari
  extend ActiveSupport::Concern

  def resources_with_pagination(resources)
    {
      pagination: {
        pages: resources.total_pages,
        count: resources.total_count,
      },
    }
  end
end
