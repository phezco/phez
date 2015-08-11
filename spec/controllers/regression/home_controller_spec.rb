require 'rails_helper'

RSpec.describe HomeController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/home').to('home#index', {}) }
	it { should route(:get, '/my').to('home#my', {}) }
	it { should route(:get, '/latest').to('home#latest', {}) }
	it { should route(:get, '/home/privacy').to('home#privacy', {}) }
	it { should route(:get, '/home/thanks').to('home#thanks', {}) }
	it { should route(:get, '/home/apidocs').to('home#apidocs', {}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end