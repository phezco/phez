class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :frozen_check!,
                only: [:new, :create]

  def index
    @messages = current_user.messages.paginate(page: params[:page])
    current_user.inbox_read!
  end

  def new
    @message = Message.new(user_id: params[:user_id])
  end

  def create
    @message = Message.new(message_params)
    @message.from_user = current_user
    if @message.save
      redirect_to build_profile_path(@message.user),
                  notice: 'Success! Message sent.'
    else
      flash[:alert] = 'There was a problem saving your message.'
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :title, :body)
  end
end
