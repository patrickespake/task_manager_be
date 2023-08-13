# frozen_string_literal: true

class Api::V1::TasksController < ApplicationController
  ITEMS_PER_PAGE = 50
  public_constant :ITEMS_PER_PAGE

  before_action :set_task, only: %i[show update destroy]

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

  def paginated_tasks
    tasks_search = current_user.tasks.ransack(search_params)
    tasks = tasks_search.result

    per_page = params[:per_page].present? ? [params[:per_page].to_i, ITEMS_PER_PAGE].min : ITEMS_PER_PAGE

    tasks.page(params[:page]).per(per_page)
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

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :priority)
  end

  def search_params
    return {} unless params[:q].present?

    params.require(:q).permit(:status_eq, :due_date_eq, :priority_eq)
  end
end
