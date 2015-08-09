require 'rails_helper'

RSpec.describe VotesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/votes/upvote').to('votes#upvote', {}) } 
	it { should route(:post, '/votes/downvote').to('votes#downvote', {}) } 
	it { should route(:post, '/votes/delete_vote').to('votes#delete_vote', {}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:frozen_check!) }
	it { should use_before_filter(:set_post) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end