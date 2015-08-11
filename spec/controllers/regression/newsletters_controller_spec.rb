require 'rails_helper'

RSpec.describe NewslettersController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/newsletters/new').to('newsletters#new', {}) }
	it { should route(:post, '/newsletters').to('newsletters#create', {}) } 
	it { should route(:get, '/newsletters/1/confirm').to('newsletters#confirm', {:id=>"1"}) }
	it { should route(:get, '/newsletters/1/unsubscribe').to('newsletters#unsubscribe', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end