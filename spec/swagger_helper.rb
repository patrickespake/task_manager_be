# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API',
        version: 'v1',
      },
      components: {
        schemas: {
          ErrorObject: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/ErrorsMap',
                },
              },
            },
          },
          ErrorsMap: {
            type: :object,
            properties: {
              detail: { type: :string },
              source: {
                type: :object,
                properties: {
                  pointer: { type: :string },
                },
              },
            },
          },
          CustomError: {
            type: :object,
            properties: {
              model: { type: :string, 'x-nullable': true },
              custom_errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    source: { type: :string },
                    detail: { type: :string },
                  },
                },
              },
              errors_json: {
                type: :object,
                properties: {
                  errors: { type: :array, items: {} },
                },
              },
            },
          },
          User: {
            type: :object,
            properties: {
              name: { type: :string, example: 'John Doe' },
              email: { type: :string, example: 'johndoe@example.com' },
              created_at: { type: :string, format: 'date-time', example: '2023-08-12T11:56:37.149Z' },
              updated_at: { type: :string, format: 'date-time', example: '2023-08-12T11:56:37.149Z' },
            },
          },
          Task: {
            type: :object,
            properties: {
              id: { type: :string, format: 'uuid', example: '8154fa08-4523-47db-abde-388301e43318' },
              type: { type: :string, example: 'task' },
              attributes: {
                type: :object,
                properties: {
                  title: { type: :string, example: 'Sample Task' },
                  description: { type: %i[string null], example: 'Sample description.' },
                  status: { type: :string, example: 'incomplete', enum: ['incomplete', 'completed'] },
                  due_date: { type: %i[string null], format: 'date', example: '2023-10-12' },
                  priority: { type: :string, example: 'low', enum: ['low', 'medium', 'high'] },
                  created_at: { type: :string, format: 'date-time', example: '2023-08-12T20:07:00.126Z' },
                  updated_at: { type: :string, format: 'date-time', example: '2023-08-12T20:07:00.126Z' },
                },
              },
              relationships: {
                type: :object,
                properties: {
                  user: { '$ref' => '#/components/schemas/UserRelationship' },
                  versions: { '$ref' => '#/components/schemas/VersionsRelationship' }
                }
              }
            },
          },
          Version: {
            type: :object,
            properties: {
              id: { type: :string, format: 'uuid' },
              type: { type: :string, example: 'version' },
              attributes: {
                type: :object,
                properties: {
                  event: { type: :string, example: 'create' },
                  changeset: { type: :object }, # This is a placeholder. Adjust according to the application's needs.
                  created_at: { type: :string, format: 'date-time', example: '2023-08-12T20:07:00.126Z' }
                }
              }
            }
          },
          Included: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string },
                attributes: { type: :object }
              }
            }
          },                     
          UserRelationship: {
            type: :object,
            properties: {
              data: { '$ref' => '#/components/schemas/UserReference' },
            },
          },
          UserReference: {
            type: :object,
            properties: {
              id: { type: :string, format: 'uuid', example: 'be210d3f-8765-4c91-ba89-4ae335bbdd45' },
              type: { type: :string, example: 'user' }
            }
          },
          VersionsRelationship: {
            type: :object,
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/VersionReference' }
              },
            },
          },
          VersionReference: {
            type: :object,
            properties: {
              id: { type: :string, format: 'uuid', example: '61618027-b1bf-4fb0-8285-0e014b1cd60c' },
              type: { type: :string, example: 'version' }
            }
          },
        },
        securitySchemes: {
          Bearer: {
            in: :header,
            name: :authorization,
            type: :apiKey,
            require: true,
            description: 'Bearer Token',
          },
        },
      },
      paths: {},
      servers: [
        {
          url: '{defaultHost}',
          variables: {
            defaultHost: {
              default: ENV['HOST'],
            },
          },
        },
      ],
    },
  }

  config.swagger_format = :yaml
end
