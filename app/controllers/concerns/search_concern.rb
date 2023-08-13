# frozen_string_literal: true

module SearchConcern
  extend ActiveSupport::Concern

  private

  def filtered_tasks
    tasks = current_user.tasks
    tasks = tasks.search_by_title_and_description(params[:keyword]) if params[:keyword].present?
    tasks_search = tasks.ransack(search_params)
    tasks_search.result
  end

  def search_params
    return {} unless params[:q].present?

    params.require(:q).permit(:status_eq, :due_date_eq, :priority_eq)
  end
end
