# spec/swagger_helper.rb

require 'rails_helper'
require 'rswag/specs'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        securitySchemes: {
          ApiKeyAuth: {
            type: :apiKey,
            name: 'Authorization',
            in: :header
          }
        }
      },
      security: [
        { ApiKeyAuth: [] }
      ]
    }
  }

  config.swagger_format = :yaml
end
