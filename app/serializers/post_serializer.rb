class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :submitted_by, :subphez, :comments_url, :comment_count, :vote_total, :upvote_total, :downvote_total, :created_at, :updated_at

  def comments_url
    object.full_post_url
  end

  def subphez
    object.subphez.path
  end

  def submitted_by
    object.user.username
  end

  def url
    object.full_url
  end

end