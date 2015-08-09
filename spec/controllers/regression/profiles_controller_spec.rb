require 'rails_helper'

RSpec.describe ProfilesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/profiles/1').to('profiles#show', {:id=>"1"}) }
	it { should route(:get, '/profiles/1/comments').to('profiles#comments', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:set_by_username) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end