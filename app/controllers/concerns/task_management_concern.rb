# frozen_string_literal: true

module TaskManagementConcern
  extend ActiveSupport::Concern

  included { before_action :set_task, only: %i[show update destroy] }

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :priority)
  end
end
