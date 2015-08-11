require 'rails_helper'

RSpec.describe Api::V1::SubphezesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/subphezes/top').to('api/v1/subphezes#top', {:format=>:json}) }
	it { should route(:get, '/api/v1/subphezes/1/all').to('api/v1/subphezes#all', {:path=>"1", :format=>:json}) }
	it { should route(:get, '/api/v1/subphezes/1/latest').to('api/v1/subphezes#latest', {:path=>"1", :format=>:json}) }
	it { should route(:post, '/api/v1/subphezes/1/subscribe').to('api/v1/subphezes#subscribe', {:path=>"1", :format=>:json}) } 
	it { should route(:post, '/api/v1/subphezes/1/unsubscribe').to('api/v1/subphezes#unsubscribe', {:path=>"1", :format=>:json}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:set_cors_headers) }
	it { should use_before_filter(:set_subphez_by_path) }
	it { should use_before_filter(:doorkeeper_authorize!) }
	it { should use_before_filter(:authenticate_user!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end