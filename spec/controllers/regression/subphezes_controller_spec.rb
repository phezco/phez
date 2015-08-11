require 'rails_helper'

RSpec.describe SubphezesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/subphezes/autocomplete').to('subphezes#autocomplete', {}) }
	it { should route(:get, '/subphezes').to('subphezes#index', {}) }
	it { should route(:get, '/p/1').to('subphezes#show', {:path=>"1"}) }
	it { should route(:get, '/p/1/latest').to('subphezes#latest', {:path=>"1"}) }
	it { should route(:get, '/p/1/manage').to('subphezes#manage', {:path=>"1"}) }
	it { should route(:post, '/p/1/add_moderator').to('subphezes#add_moderator', {:path=>"1"}) } 
	it { should route(:post, '/p/1/remove_moderator').to('subphezes#remove_moderator', {:path=>"1"}) } 
	it { should route(:get, '/p/1/approve_modrequest').to('subphezes#approve_modrequest', {:path=>"1"}) }
	it { should route(:post, '/p/1/update_modrequest').to('subphezes#update_modrequest', {:path=>"1"}) } 
	it { should route(:get, '/subphezes/new').to('subphezes#new', {}) }
	it { should route(:get, '/subphezes/1/edit').to('subphezes#edit', {:id=>"1"}) }
	it { should route(:post, '/subphezes').to('subphezes#create', {}) } 
	it { should route(:patch, '/subphezes/1').to('subphezes#update', {:id=>"1"}) } 
	it { should route(:get, '/random').to('subphezes#random', {}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:set_subphez) }
	it { should use_before_filter(:set_subphez_by_path) }
	it { should use_before_filter(:frozen_check!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end