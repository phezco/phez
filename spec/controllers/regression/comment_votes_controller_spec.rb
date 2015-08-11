require 'rails_helper'

RSpec.describe CommentVotesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:post, '/comment_votes/upvote').to('comment_votes#upvote', {}) } 
	it { should route(:post, '/comment_votes/downvote').to('comment_votes#downvote', {}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:verify_authenticity_token) }
	it { should use_before_filter(:set_xhr_redirected_to) }
	it { should use_before_filter(:set_request_method_cookie) }
	it { should use_before_filter(:configure_permitted_parameters) }
	it { should use_before_filter(:authenticate_user!) }
	it { should use_before_filter(:set_comment) }
	it { should use_before_filter(:frozen_check!) }
  # === Callbacks (After) ===
  it { should use_after_filter(:abort_xdomain_redirect) }
	it { should use_after_filter(:verify_same_origin_request) }
  # === Callbacks (Around) ===
  
end