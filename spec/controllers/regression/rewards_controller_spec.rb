require 'rails_helper'

RSpec.describe RewardsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/rewards/new').to('rewards#new', {}) }
	it { should route(:get, '/rewards/premium').to('rewards#premium', {}) }
	it { should route(:post, '/rewards').to('rewards#create', {}) } 
	it { should route(:post, '/rewards/create_rewardable').to('rewards#create_rewardable', {}) } 
	it { should route(:get, '/rewards/1/thanks').to('rewards#thanks', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:frozen_check!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end