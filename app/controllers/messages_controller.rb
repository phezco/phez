class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = current_user.messages
    current_user.inbox_read!
  end

end