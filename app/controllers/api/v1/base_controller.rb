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

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def authenticate_user!
    if doorkeeper_token
      #Thread.current[:current_user] = User.find(doorkeeper_token.resource_owner_id)
      current_user = User.find(doorkeeper_token.resource_owner_id)
    end

    return if current_user

    render json: { errors: ['User is not authenticated!'] }, status: :unauthorized
  end

end
