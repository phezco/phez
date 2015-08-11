class RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = 'There was an error with your reCAPTCHA. Please check "I\'m not a robot" below.'
      flash.delete :recaptcha_error
      render :new
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_sign_up_path_for(_resource)
    session[:previous_url] || root_path
  end
end
