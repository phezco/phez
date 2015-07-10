class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def build_subphez_path(subphez)
    view_subphez_path(:path => subphez.path)
  end
  helper_method :build_subphez_path

  def build_post_path(post)
    view_post_path(:path => post.subphez.path, :post_id => post.id, :guid => post.guid)
  end
  helper_method :build_post_path

end
