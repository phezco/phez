require 'test_helper'

class SubphezesControllerTest < ActionController::TestCase
  test 'route for random subphez' do
    assert_routing '/random', controller: 'subphezes', action: 'random'
  end

  test 'should redirect to show a subphez' do
    FactoryGirl.create(:subphez)
    FactoryGirl.create(:subphez, :dogs, user: FactoryGirl.create(:user, :bar))
    valid_pathname = /[a-zA-Z0-9]+/
    get :random
    assert_response :redirect
    assert_redirected_to %r{\Ahttp://test.host/p/#{valid_pathname}\Z}
  end
end
