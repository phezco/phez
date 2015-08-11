require 'rails_helper'

RSpec.describe AdminController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/admin').to('admin#index', {}) }
	it { should route(:get, '/admin/payments_csv').to('admin#payments_csv', {}) }
	it { should route(:get, '/admin/microtip_csv').to('admin#microtip_csv', {}) }
	it { should route(:get, '/admin/transactions').to('admin#transactions', {}) }
	it { should route(:post, '/admin/create_transaction').to('admin#create_transaction', {}) } 
	it { should route(:get, '/admin/users').to('admin#users', {}) }
	it { should route(:patch, '/admin/1/unfreeze').to('admin#unfreeze', {:id=>"1"}) } 
	it { should route(:patch, '/admin/1/make_ineligible').to('admin#make_ineligible', {:id=>"1"}) } 
	it { should route(:patch, '/admin/1/make_eligible').to('admin#make_eligible', {:id=>"1"}) } 
	it { should route(:patch, '/admin/1/freeze').to('admin#freeze', {:id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:require_admin!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end