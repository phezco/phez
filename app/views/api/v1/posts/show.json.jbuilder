json.id @post.id
json.title @post.title
json.url @post.full_url
json.comments_url @post.full_post_url
json.comments @post.root_comments do |comment|
  json.partial! 'comment', comment: comment
end
