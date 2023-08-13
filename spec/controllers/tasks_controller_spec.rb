# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user:) }
  let(:application) { create(:application) }
  let(:token) { create(:access_token, resource_owner_id: user.id, application:) }

  before { request.headers['Authorization'] = "Bearer #{token.token}" }

  describe 'GET #index' do
    it 'returns tasks for the user' do
      get :index, format: :json
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(parsed_response['data'].length).to eq(1)
    end

    context 'when filtering by status' do
      let!(:completed_task) { create(:task, user:, status: 'completed') }

      it 'returns tasks with the specified status' do
        get :index, params: { q: { status_eq: 1 } }, format: :json
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(parsed_response['data'].first['attributes']['status']).to eq('completed')
      end
    end

    context 'when filtering by due_date' do
      let!(:future_task) { create(:task, user:, due_date: 1.week.from_now) }

      it 'returns tasks with the specified due_date' do
        get :index, params: { q: { due_date_eq: future_task.due_date } }, format: :json
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(parsed_response['data'].length).to eq(1)
        expect(Date.parse(parsed_response['data'].first['attributes']['due_date'])).to eq(future_task.due_date)
      end
    end

    context 'when filtering by priority' do
      let!(:high_priority_task) { create(:task, user:, priority: 'high') }

      it 'returns tasks with the specified priority' do
        get :index, params: { q: { priority_eq: 2 } }, format: :json
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(parsed_response['data'].first['attributes']['priority']).to eq('high')
      end
    end

    context 'when searching by keyword' do
      let!(:task_with_keyword) do
        create(:task, user:, title: 'Test keyword', description: 'This is a description with keyword.')
      end

      it 'returns tasks matching the keyword' do
        get :index, params: { keyword: 'keyword' }, format: :json
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(parsed_response['data'].length).to eq(1)
        expect(parsed_response['data'].first['attributes']['title']).to include('keyword')
      end
    end

    context 'when using pagination parameters' do
      before { 5.times { create(:task, user:) } }

      it 'returns the specified number of tasks per page' do
        get :index, params: { per_page: 3, page: 1 }, format: :json
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(parsed_response['data'].length).to eq(3)
        expect(parsed_response['meta']['total_pages']).to eq(2)
      end
    end
  end

  describe 'GET #show' do
    it 'returns the specified task' do
      get :show, params: { id: task.id }, format: :json
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(parsed_response['data']['attributes']['title']).to eq(task.title)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new task' do
        expect { post(:create, params: { task: attributes_for(:task) }, format: :json) }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new task' do
        expect do
          post(:create, params: { task: { title: '', description: 'Invalid task' } }, format: :json)
        end.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_title) { 'Updated Task Title' }

    context 'with valid attributes' do
      it 'updates the task' do
        put :update, params: { id: task.id, task: { title: new_title } }, format: :json
        task.reload

        expect(response).to have_http_status(:success)
        expect(task.title).to eq(new_title)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the task' do
        put :update, params: { id: task.id, task: { title: '' } }, format: :json
        task.reload

        expect(response).to have_http_status(:unprocessable_entity)
        expect(task.title).not_to eq('')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the task' do
      expect { delete(:destroy, params: { id: task.id }, format: :json) }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
