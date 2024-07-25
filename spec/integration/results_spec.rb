# spec/integration/results_spec.rb

require 'swagger_helper'

RSpec.describe 'api/v1/results_data', type: :request do
  path '/api/v1/results_data' do
    post 'Creates a result' do
      tags 'Results'
      consumes 'application/json'
      security [ ApiKeyAuth: [] ]
      parameter name: :result, in: :body, schema: {
        type: :object,
        properties: {
          result: {
            type: :object,
            properties: {
              subject: { type: :string },
              timestamp: { type: :string, format: :date_time },
              marks: { type: :number }
            },
            required: [ 'subject', 'timestamp', 'marks' ]
          }
        },
        required: [ 'result' ]
      }

      response '201', 'result created' do
        let(:Authorization) { 'your_api_key_here' }
        let(:result) { { result: { subject: 'English', timestamp: '2024-07-24T23:15:46.221Z', marks: 45 } } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid_api_key' }
        let(:result) { { result: { subject: 'English', timestamp: '2024-07-24T23:15:46.221Z', marks: 45 } } }
        run_test!
      end
    end
  end
end
