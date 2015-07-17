class UsersController < ApplicationController
  before_action :authenticate_user!

  def subscriptions
    @subphezes = current_user.subscribed_subphezes
  end

  def change_password
  end

  def update_password
    if user_params[:password].blank? || user_params[:password_confirmation].blank?
      flash[:alert] = "Please enter a valid password (cannot be blank)."
      render :change_password
      return
    end

    if current_user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in current_user, :bypass => true
      redirect_to edit_user_registration_path, notice: 'Success! Password updated.'
    else
      flash[:alert] = "There was a problem updating your password."
      render :change_password
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

end