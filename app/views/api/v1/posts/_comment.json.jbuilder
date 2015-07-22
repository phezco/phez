json.body comment.body_rendered
json.username comment.user.username
json.vote_total comment.vote_total
json.upvote_total comment.upvote_total
json.downvote_total comment.downvote_total
if comment.has_children?
  json.comments comment.children do |comment|
    json.partial! 'comment', comment: comment
  end
end