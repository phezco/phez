json.messages @messages do |message|
  json.reason message.reason
  json.from_user (message.from_user.nil? ? nil : message.from_user.username)
  json.via_system message.from_user.nil?
  json.title message.title
  if message.messageable
    @comment = message.messageable
    body = "#{link_to raw(@comment.commentable.title), build_post_path(@comment.commentable)} %> by #{link_to @comment.commentable.user.username, build_profile_path(@comment.commentable.user)} in #{link_to @comment.commentable.subphez.path, build_subphez_path(@comment.commentable.subphez)}:<br>"
    body += "#{link_to @comment.user.username, build_profile_path(@comment.user)} said: <br>"
    body += @comment.body_rendered
    json.body body
  else
    json.body message.body_rendered
  end
  json.created_at message.created_at
end
