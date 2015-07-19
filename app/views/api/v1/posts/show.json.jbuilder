json.id @post.id
json.self @post.is_self
json.title @post.title
json.url @post.full_url
json.body @post.body
json.comments_url @post.full_post_url
json.comments @post.root_comments do |comment|
  json.partial! 'comment', comment: comment
end
