class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    if params[:parent_id]
      @parent = Comment.find(params[:parent_id])
    end
    @comment = Comment.build_from( @post, current_user.id, params[:comment][:body] )
    if @comment.save
      flash[:notice] = "Your comment was successfully posted."
      if @parent
        @comment.move_to_child_of(@parent)
      end
    else
      flash[:alert] = "There was a problem saving your comment."
    end
    redirect_to build_post_path(@post)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.nil?
      redirect_to root_path, alert: "Could not find comment to delete." and return
    end
    unless @comment.owner?(current_user) || @comment.moderatable?(current_user)
      redirect_to root_path, alert: "You are not allowed to do that." and return
    end
    @comment.delete!
    redirect_to build_post_path(@comment.commentable), notice: 'Success! Comment deleted.'
  end

end
