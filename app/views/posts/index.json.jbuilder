json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :subphez_id, :url, :title, :vote_total, :is_self, :body
  json.url post_url(post, format: :json)
end
