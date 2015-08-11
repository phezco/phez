class ApplicationController < ActionController::Base
  include ActionView::Helpers::DateHelper

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
    return true unless subphez.is_premium_only
    unless user_signed_in? and current_user.is_premium
      redirect_to root_path, alert: 'You must be a premium user to access that content. Please consider buying some Phez Premium.'
      return false
    end
  end

  def after_sign_in_path_for(_resource)
    session[:previous_url] || root_path
  end

  def throttle
    return true unless user_signed_in?
    return true if current_user.is_admin || current_user.throttle_exempt
    if current_user.throttled_until
      if current_user.throttled_until > DateTime.now
        throttle_message = "Woah there cowboy! You seem to be doing that awfully fast. Are you some kind of super-human ninja wizard?!?! Please wait #{time_ago_in_words(current_user.throttled_until)} from now before trying that again."
        redirect_to root_path, alert: throttle_message and return false
      else
        current_user.update_attribute(:throttled_until, nil) and return true
      end
    else
      @last_five_minutes_post_count = current_user.posts.last_five_minutes.count
      @last_five_minutes_comment_count = current_user.comments.last_five_minutes.count
      if (@last_five_minutes_post_count >= 5) || (@last_five_minutes_comment_count >= 5)
        current_user.update_attribute(:throttled_until, 30.minutes.from_now)
        throttle_message = "Woah there cowboy! You seem to be doing that awfully fast. Are you some kind of super-human ninja wizard?!?! Please wait #{time_ago_in_words(current_user.throttled_until)} from now before trying that again."
        redirect_to root_path, alert: throttle_message and return false
      end
    end
  end

  def frozen_check!
    return true unless user_signed_in?
    if current_user.is_frozen
      redirect_to root_path, alert: 'Your account has been frozen due to suspicious activity or attempting to game the system.'
      return false
    end
    true
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :bitcoin_address) }
  end
end
