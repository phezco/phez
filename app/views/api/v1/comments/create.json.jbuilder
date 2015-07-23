json.success true
json.comment do
  json.partial! 'api/v1/posts/comment', comment: @comment
end
