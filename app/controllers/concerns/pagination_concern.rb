# frozen_string_literal: true

module PaginationConcern
  extend ActiveSupport::Concern

  ITEMS_PER_PAGE = 50
  public_constant :ITEMS_PER_PAGE

  private

  def paginated_tasks
    tasks = filtered_tasks

    per_page = determine_items_per_page
    tasks.page(params[:page]).per(per_page)
  end

  def determine_items_per_page
    params[:per_page].present? ? [params[:per_page].to_i, ITEMS_PER_PAGE].min : ITEMS_PER_PAGE
  end

  def pagination_meta(tasks)
    {
      current_page: tasks.current_page,
      total_pages: tasks.total_pages,
      total_count: tasks.total_count,
      next_page: tasks.next_page,
      prev_page: tasks.prev_page,
    }
  end
end
