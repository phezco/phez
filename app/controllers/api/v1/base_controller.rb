class Api::V1::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :set_cors_headers

  clear_respond_to
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: errors_json(e.message), status: :not_found
  end

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def errors_json(messages)
    { errors: [*messages] }
  end
end
