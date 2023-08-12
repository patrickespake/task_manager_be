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
