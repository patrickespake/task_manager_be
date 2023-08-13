# frozen_string_literal: true

class Api::V1::TasksController < ApplicationController
  include PaginationConcern
  include SearchConcern
  include TaskManagementConcern

  def index
    tasks = paginated_tasks
    render json: ::TaskSerializer.new(tasks, meta: pagination_meta(tasks))
  end

  def show
    render json: ::TaskSerializer.new(@task, json_options)
  end

  def create
    task = current_user.tasks.new(task_params)

    if task.save
      render json: ::TaskSerializer.new(task, json_options), status: :created
    else
      render json: ::ErrorSerializer.new(task).serialized_json, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: ::TaskSerializer.new(@task, json_options)
    else
      render json: ::ErrorSerializer.new(@task).serialized_json, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head(:no_content)
  end

  private

  def json_options
    { include: %i[user versions] }
  end
end
