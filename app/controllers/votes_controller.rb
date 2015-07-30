class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :frozen_check!
  before_action :set_post

  def upvote
    respond_to do |format|
      if Vote.upvote(current_user, @post)
        json = { 'success' => true, 'post_id' => @post.id }
        format.json { render json: json, status: :created }
      else
        json = {
          'success' => false,
          'post_id' => @post.id,
          'error' => 'There was a problem saving your vote.'
        }
        format.json { render json: json, status: :bad_request }
      end
    end
  end

  def downvote
    respond_to do |format|
      if Vote.downvote(current_user, @post)
        json = { 'success' => true, 'post_id' => @post.id }
        format.json { render json: json, status: :created }
      else
        json = {
          'success' => false,
          'post_id' => @post.id,
          'error' => 'There was a problem saving your vote.'
        }
        format.json { render json: json, status: :bad_request }
      end
    end
  end

  def delete_vote
    respond_to do |format|
      if Vote.delete_vote(current_user, @post)
        json = { 'success' => true, 'post_id' => @post.id }
        format.json { render json: json, status: :created }
      else
        json = {
          'success' => false,
          'post_id' => @post.id,
          'error' => 'There was a problem deleting your vote.'
        }
        format.json { render json: json, status: :bad_request }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
