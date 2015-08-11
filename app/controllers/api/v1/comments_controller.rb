class Api::V1::CommentsController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @parent = Comment.find(params[:parent_id]) if params[:parent_id]
    @comment = Comment.build_from(@post, current_resource_owner.id, params[:body])
    if @comment.save
      if @parent
        @comment.move_to_child_of(@parent)
        @comment.add_reply_message
      end
    else
      errors_text = @comment.errors.full_messages.join('; ')
      json = { 'success' => false, 'errors' => errors_text }
      render json: json
      return
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    unless @comment.owner?(current_resource_owner) || @comment.moderatable?(current_resource_owner)
      json = { 'success' => false, 'errors' => 'You are not allowed to do that.' }
      render json: json, status: :unauthorized
    end
    @comment.delete!
    json = { 'success' => true }
    render json: json
  end
end
