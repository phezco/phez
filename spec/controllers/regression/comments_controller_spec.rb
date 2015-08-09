require 'rails_helper'

RSpec.describe CommentsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/comments/1').to('comments#show', {:id=>"1"}) }
	it { should route(:get, '/comments/1/edit').to('comments#edit', {:id=>"1"}) }
	it { should route(:patch, '/comments/1').to('comments#update', {:id=>"1"}) } 
	it { should route(:post, '/comments').to('comments#create', {}) } 
	it { should route(:delete, '/comments/1').to('comments#destroy', {:id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:throttle) }
	it { should use_before_filter(:frozen_check!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end