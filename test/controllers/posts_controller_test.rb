require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
  end

  test "should redirect on get new (not authenticated)" do
    get :new
    assert_response :redirect
  end

  test "should get new (authenticated)" do
    @user = FactoryGirl.create(:user)
    sign_in(@user)
    get :new
    assert_response :success
  end

  test "should create post (authenticated)" do
    @subphez = FactoryGirl.create(:subphez)
    sign_in(@subphez.user)
    assert_difference('Post.count') do
      post :create, subphez_path: @subphez.path, post: { body: '', title: 'Hello world', url: 'http://google.com' }
    end
    refute assigns(:post).is_self
    assert_redirected_to view_post_path(path: @subphez.path, post_id: assigns(:post).id, guid: assigns(:post).guid)
  end

  test "should show post" do
    @post = FactoryGirl.create(:post)
    get :show, post_id: @post.id, path: @post.subphez.path, guid: @post.guid
    assert_response :success
  end

  test "should be redirect on get edit (not authenticated)" do
    @post = FactoryGirl.create(:post)
    get :edit, id: @post
    assert_response :redirect
  end

  test "should get edit (authenticated post owner)" do
    @post = FactoryGirl.create(:post)
    sign_in(@post.user)
    get :edit, id: @post
    assert_response :success
  end

  test "should be redirected on get edit (authenticated non-post owner)" do
    @request.env['HTTP_REFERER'] = 'http://test.host/p/cats/submit'

    @post = FactoryGirl.create(:post)
    @non_owner = FactoryGirl.create(:user, :bar)
    sign_in(@non_owner)
    get :edit, id: @post
    assert_response :redirect
  end

  test "should update post (authenticated post owner)" do
    @post = FactoryGirl.create(:post, :selfpost)
    sign_in(@post.user)
    patch :update, id: @post, post: { body: 'Updated body', title: 'Updated Title' }
    assert_equal 'Updated body', assigns(:post).body
    assert_equal 'Updated Title', assigns(:post).title
    assert_match /successfully updated/, flash[:notice]
    assert_redirected_to view_post_path(path: @post.subphez.path, post_id: @post.id, guid: assigns(:post).guid)
  end

  test "should not update post (authenticated non-post owner)" do
    @request.env['HTTP_REFERER'] = 'http://test.host/'

    @post = FactoryGirl.create(:post, :selfpost)
    @non_owner = FactoryGirl.create(:user, :bar)
    sign_in(@non_owner)
    patch :update, id: @post, post: { body: 'Updated body', title: 'Updated Title' }
    assert_equal @post.body, assigns(:post).body
    assert_equal @post.title, assigns(:post).title
    assert_response :redirect
  end

  test "should destroy post (authenticated post owner)" do
    @request.env['HTTP_REFERER'] = 'http://test.host/cats/1/post-guid'
    @post = FactoryGirl.create(:post, :selfpost)
    sign_in(@post.user)
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end
    assert_match /successfully destroyed/, flash[:notice]
    assert_response :redirect
  end

  test "should not destroy post (authenticated non-post owner)" do
    @request.env['HTTP_REFERER'] = 'http://test.host/'

    @post = FactoryGirl.create(:post)
    @non_owner = FactoryGirl.create(:user, :bar)
    sign_in(@non_owner)
    assert_difference('Post.count', 0) do
      delete :destroy, id: @post
    end
    assert_response :redirect
  end

end
