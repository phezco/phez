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

end
