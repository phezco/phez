json.comments @comments do |comment|
  json.post_id comment.commentable.id
  json.url comment.url
  json.body comment.body_rendered
  json.vote_total comment.vote_total
  json.upvote_total comment.upvote_total
  json.downvote_total comment.downvote_total
end
