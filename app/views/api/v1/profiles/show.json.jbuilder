json.post_karma @user.link_karma
json.comment_karma @user.comment_karma
json.created_at @user.created_at
json.post_count @user.posts.count
json.comment_count @user.comments.count
