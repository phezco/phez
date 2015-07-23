class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subphez

  def create
    if Subscription.subscribe!(@subphez, current_user)
      redirect_to :back,
                  notice: "Success! You have subscribed to /p/#{@subphez.path}."
    else
      redirect_to :back,
                  alert: 'There was an error processing your subscribe request.'
    end
  end

  def destroy
    Subscription.unsubscribe!(@subphez, current_user)
    redirect_to :back,
                notice: "You have been unsubscribed from /p/#{@subphez.path}."
  end

  private

  def set_subphez
    @subphez = Subphez.find(params[:subphez_id])
  end
end
