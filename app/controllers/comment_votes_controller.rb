class CommentVotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment
  before_action :frozen_check!

  def upvote
    respond_to do |format|
      if CommentVote.upvote(current_user, @comment)
        json = { 'success' => true, 'comment_id' => @comment.id }
        format.json { render json: json, status: :created }
      else
        json = {
          'success' => false,
          'comment_id' => @comment.id,
          'error' => 'There was a problem saving your vote.'
        }
        format.json { render json: json, status: :bad_request }
      end
    end
  end

  def downvote
    respond_to do |format|
      if CommentVote.downvote(current_user, @comment)
        json = { 'success' => true, 'comment_id' => @comment.id }
        format.json { render json: json, status: :created }
      else
        json = {
          'success' => false,
          'comment_id' => @comment.id,
          'error' => 'There was a problem saving your vote.'
        }
        format.json { render json: json, status: :bad_request }
      end
    end
  end

  private

  def set_comment
    @comment = Comment.where(id: params[:comment_id]).first
    if @comment.nil?
      respond_to do |format|
        json = { 'success' => false }
        format.json { render json: json, status: :bad_request }
      end
      return
    end
  end
end
