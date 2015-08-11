class NewslettersController < ApplicationController
  def new
    @newsletter_subscriber = NewsletterSubscriber.new
  end

  def create
    @newsletter_subscriber = NewsletterSubscriber.new(newsletter_params)
    if @newsletter_subscriber.save
      redirect_to root_path, notice: 'Success! Please check your email to confirm your email address.'
    else
      flash[:alert] = 'There was a problem saving your subscription. Please enter a valid email address.'
      render action: :new
    end
  end

  def confirm
    @newsletter_subscriber = NewsletterSubscriber.where(secret: params[:id]).first
    if @newsletter_subscriber
      @newsletter_subscriber.is_confirmed = true
      @newsletter_subscriber.save
      redirect_to root_path, notice: 'Thanks! Your email has been confirmed. You will now begin receiving Phez top posts by email.'
    else
      redirect_to root_path, alert: 'Could not find newsletter subscription to confirm.'
    end
  end

  def unsubscribe
    @newsletter_subscriber = NewsletterSubscriber.where(secret: params[:id]).first
    if @newsletter_subscriber
      @newsletter_subscriber.destroy
      redirect_to root_path, notice: 'You have been unsubscribed from the Phez newsletter.'
    else
      redirect_to root_path, alert: 'Could not find newsletter subscription.'
    end
  end

  private

  def newsletter_params
    params.require(:newsletter_subscriber).permit(:email)
  end
end
