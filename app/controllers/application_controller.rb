class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def build_profile_path(user)
    profile_path(id: user.username)
  end
  helper_method :build_profile_path

  def build_subphez_path(subphez)
    view_subphez_path(path: subphez.path)
  end
  helper_method :build_subphez_path

  def build_post_path(post)
    view_post_path(path: post.subphez.path, post_id: post.id, guid: post.guid)
  end
  helper_method :build_post_path

  def require_admin!
    unless current_user.is_admin
      redirect_to root_path, alert: "You can't do that."
    end
  end

  def disallow_non_premium(subphez)
    return true if !subphez.is_premium_only
    unless user_signed_in? && current_user.is_premium
      redirect_to root_path, alert: 'You must be a premium user to access that content. Please consider buying some Phez Premium.'
      return false
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :bitcoin_address) }
  end
end
