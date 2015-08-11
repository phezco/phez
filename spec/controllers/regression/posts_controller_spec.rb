require 'rails_helper'

RSpec.describe PostsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/posts/suggest_title').to('posts#suggest_title', {}) }
	it { should route(:get, '/posts/1').to('posts#show', {:id=>"1"}) }
	it { should route(:get, '/p/1/submit').to('posts#new', {:path=>"1"}) }
	it { should route(:get, '/posts/1/edit').to('posts#edit', {:id=>"1"}) }
	it { should route(:post, '/posts').to('posts#create', {}) } 
	it { should route(:patch, '/posts/1').to('posts#update', {:id=>"1"}) } 
	it { should route(:delete, '/posts/1').to('posts#destroy', {:id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:set_post) }
	it { should use_before_filter(:throttle) }
	it { should use_before_filter(:frozen_check!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end