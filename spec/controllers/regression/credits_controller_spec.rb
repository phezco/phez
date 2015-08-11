require 'rails_helper'

RSpec.describe CreditsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/credits/transactions').to('credits#transactions', {}) }
	it { should route(:post, '/credits/create_transactions').to('credits#create_transactions', {}) } 
	it { should route(:get, '/credits/leaderboard').to('credits#leaderboard', {}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:require_admin!) }
	it { should use_before_filter(:setup_vars) }
	it { should use_before_filter(:setup_users) }
	it { should use_before_filter(:setup_earnings_hash) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end