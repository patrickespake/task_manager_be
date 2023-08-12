# frozen_string_literal: true

class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    tasks = current_user.tasks
    render json: ::TaskSerializer.new(tasks)
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

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :priority)
  end
end
