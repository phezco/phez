require 'rails_helper'

RSpec.describe Api::V1::CommentsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/api/v1/comments').to('api/v1/comments#create', {:format=>:json}) } 
	it { should route(:delete, '/api/v1/comments/1').to('api/v1/comments#destroy', {:id=>"1", :format=>:json}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:set_cors_headers) }
	it { should use_before_filter(:doorkeeper_authorize!) }
	it { should use_before_filter(:authenticate_user!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end