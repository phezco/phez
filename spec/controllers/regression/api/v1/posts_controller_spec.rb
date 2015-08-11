require 'rails_helper'

RSpec.describe Api::V1::PostsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/posts/all').to('api/v1/posts#all', {:format=>:json}) }
	it { should route(:get, '/api/v1/posts/my').to('api/v1/posts#my', {:format=>:json}) }
	it { should route(:get, '/api/v1/posts/1').to('api/v1/posts#show', {:id=>"1", :format=>:json}) }
	it { should route(:post, '/api/v1/posts/create').to('api/v1/posts#create', {:format=>:json}) } 
	it { should route(:post, '/api/v1/posts/1/upvote').to('api/v1/posts#upvote', {:id=>"1", :format=>:json}) } 
	it { should route(:post, '/api/v1/posts/1/downvote').to('api/v1/posts#downvote', {:id=>"1", :format=>:json}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:set_cors_headers) }
	it { should use_before_filter(:doorkeeper_authorize!) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:set_post) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end