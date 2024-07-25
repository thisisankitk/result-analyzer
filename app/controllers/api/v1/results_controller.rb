# app/controllers/api/v1/results_controller.rb

class Api::V1::ResultsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :authenticate_with_api_key!

  def create
    result = ResultData.new(result_params)
    if result.save
      render json: { status: 'success', message: 'Result created successfully' }, status: :created
    else
      render json: { status: 'error', message: result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_with_api_key!
    api_key = request.headers['Authorization']
    unless ApiKey.exists?(access_token: api_key)
      render json: { status: 'error', message: 'Unauthorized' }, status: :unauthorized
    end
  end

  def result_params
    params.require(:result).permit(:subject, :timestamp, :marks)
  end
end
