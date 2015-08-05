class Api::V1::UsersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :authenticate_user!

  def details
    json = { 'username' => current_resource_owner.username,
             'post_karma' => current_resource_owner.link_karma,
             'comment_karma' => current_resource_owner.comment_karma,
             'has_messages' =>  current_resource_owner.orange }
    render json: json
  end

  def inbox
    @messages = current_resource_owner.messages.paginate(page: params[:page])
    current_resource_owner.inbox_read!
  end
end
