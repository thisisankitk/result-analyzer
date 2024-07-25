require 'rails_helper'

RSpec.describe Api::V1::ResultsController, type: :controller do
  let!(:api_key) { create(:api_key) }
  let(:valid_params) { { subject: 'Science', timestamp: '2022-04-18 12:01:34.678', marks: 85.25 } }
  let(:invalid_params) { { subject: '', timestamp: '', marks: nil } }

  describe 'POST #create' do
    context 'with valid API key' do
      before do
        request.headers['Authorization'] = api_key.access_token
      end

      it 'creates a new result with valid params' do
        expect {
          post :create, params: { result: valid_params }
        }.to change(ResultData, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'does not create a new result with invalid params' do
        expect {
          post :create, params: { result: invalid_params }
        }.to_not change(ResultData, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without API key' do
      it 'returns unauthorized status' do
        post :create, params: { result: valid_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid API key' do
      before do
        request.headers['Authorization'] = 'invalid_key'
      end

      it 'returns unauthorized status' do
        post :create, params: { result: valid_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
