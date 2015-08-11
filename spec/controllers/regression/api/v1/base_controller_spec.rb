require 'rails_helper'

RSpec.describe Api::V1::BaseController, regressor: true do
  # === Routes (REST) ===
  
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:set_cors_headers) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end