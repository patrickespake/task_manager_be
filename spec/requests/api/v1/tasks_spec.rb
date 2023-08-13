# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user) { create :user }
  let(:authorization) { "Bearer #{create(:access_token, resource_owner: user).token}" }

  path '/api/v1/tasks' do
    get('list tasks') do
      tags 'Tasks'
      description 'Get a list of tasks for the currently signed-in user. ' \
                  'Supports pagination with the "page" and "per_page" query parameters. ' \
                  'You can also filter tasks by status, due date, and priority using the "q[...]" parameters.'

      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]
      parameter name: :authorization, in: :header

      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination', required: false
      parameter name: :per_page, in: :query, type: :integer, description: "Number of tasks per page (max #{Api::V1::TasksController::ITEMS_PER_PAGE})",
                required: false

      parameter name: :'q[status_eq]', in: :query, type: :string, description: 'Filter by task status', required: false
      parameter name: :'q[due_date_eq]', in: :query, type: :string, format: 'date',
                description: 'Filter by task due date', required: false
      parameter name: :'q[priority_eq]', in: :query, type: :string, description: 'Filter by task priority',
                required: false

      parameter name: :keyword, in: :query, type: :string, description: 'Keyword search by task title and description',
                required: false

      let!(:tasks) { create_list :task, 5, user: }

      response(200, 'successful') do
        let(:page) { 2 }
        let(:per_page) { 2 }

        schema type: :object, properties: {
          data: {
            type: :array,
            items: { '$ref' => '#/components/schemas/Task' },
          },
          meta: {
            type: :object,
            properties: {
              current_page: { type: :integer, example: 2 },
              total_pages: { type: :integer, example: 3 },
              total_count: { type: :integer, example: 5 },
              next_page: { type: :integer, 'x-nullable': true, example: 3 },
              prev_page: { type: :integer, 'x-nullable': true, example: 1 },
            },
            required: %w[current_page total_pages total_count],
          },
        }

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:authorization) { 'bad auth key' }
        run_test! { |response| expect(response.code).to eq('401') }
      end
    end

    post('create task') do
      tags 'Tasks'
      description 'Create a new task for the currently signed-in user'
      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]
      parameter name: :authorization, in: :header
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              status: { type: :string },
              due_date: { type: :string, format: 'date' },
              priority: { type: :string },
            },
            required: %w[title status],
          },
        },
      }

      let(:task) do
        {
          task: {
            title: 'Sample task',
            description: 'This is a description for the sample task.',
            status: 'incomplete',
            due_date: '2023-12-31',
            priority: 'high',
          },
        }
      end

      response(201, 'task created') do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Task' },
                 included: { '$ref' => '#/components/schemas/Included' },
               }

        run_test!
      end

      response(400, 'bad request') do
        let(:task) do
          {
            task: {
              title: 'Sample task',
              description: 'This is a description for the sample task.',
              status: 'invalid',
              due_date: '2023-12-31',
              priority: 'high',
            },
          }
        end

        schema '$ref' => '#/components/schemas/ErrorObject'

        run_test!
      end

      response(422, 'invalid request') do
        let(:task) { { task: { title: '', status: 'incomplete' } } }
        schema '$ref' => '#/components/schemas/ErrorObject'

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:authorization) { 'bad auth key' }
        run_test! { |response| expect(response.code).to eq('401') }
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: :id, in: :path, type: :string
    let!(:id) { create(:task, user:).id }

    get('show task') do
      tags 'Tasks'
      description 'Get details of a specific task'
      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]
      parameter name: :authorization, in: :header

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Task' },
                 included: { '$ref' => '#/components/schemas/Included' },
               }

        run_test!
      end

      response(404, 'task not found') do
        let(:id) { 'some_non_existent_id' }
        run_test! { |response| expect(response.code).to eq('404') }
      end

      response(401, 'unauthorized') do
        let!(:authorization) { 'bad auth key' }
        run_test! { |response| expect(response.code).to eq('401') }
      end
    end

    put('update task') do
      tags 'Tasks'
      description 'Update a specific task'
      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]
      parameter name: :authorization, in: :header
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              status: { type: :string },
              due_date: { type: :string, format: 'date' },
              priority: { type: :string },
            },
            required: %w[title status],
          },
        },
      }

      let(:task) do
        {
          task: {
            title: 'Updated sample task',
            description: 'Updated this is a description for the sample task.',
            status: 'completed',
            due_date: '2024-01-01',
            priority: 'low',
          },
        }
      end

      response(200, 'task updated') do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Task' },
                 included: { '$ref' => '#/components/schemas/Included' },
               }

        run_test!
      end

      response(400, 'bad request') do
        let(:task) do
          {
            task: {
              title: 'Sample task',
              description: 'This is a description for the sample task.',
              status: 'invalid',
              due_date: '2023-12-31',
              priority: 'high',
            },
          }
        end

        schema '$ref' => '#/components/schemas/ErrorObject'

        run_test!
      end

      response(422, 'update failed') do
        let(:task) { { task: { title: '', status: 'incomplete' } } }

        schema '$ref' => '#/components/schemas/ErrorObject'

        run_test!
      end

      response(404, 'task not found') do
        let(:id) { 'some_non_existent_id' }
        run_test! { |response| expect(response.code).to eq('404') }
      end

      response(401, 'unauthorized') do
        let!(:authorization) { 'bad auth key' }
        run_test! { |response| expect(response.code).to eq('401') }
      end
    end

    delete('delete task') do
      tags 'Tasks'
      description 'Delete a specific task'
      consumes 'application/json'
      produces 'application/json'

      security [Bearer: {}]
      parameter name: :authorization, in: :header

      response(204, 'task deleted') { run_test! }

      response(404, 'task not found') do
        let(:id) { 'some_non_existent_id' }
        run_test! { |response| expect(response.code).to eq('404') }
      end

      response(401, 'unauthorized') do
        let!(:authorization) { 'bad auth key' }
        run_test! { |response| expect(response.code).to eq('401') }
      end
    end
  end
end
