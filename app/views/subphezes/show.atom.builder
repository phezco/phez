atom_feed root_url: @subphez.url do |feed|
  feed.title "#{@subphez.title} :: Phez"
  feed.updated(@posts.maximum(:updated_at)) unless @posts.empty?
  @posts.latest.each do |post|
    feed.entry post, url: post.full_post_url do |entry|
      entry.title(post.title)
      entry.content(post.body)
      entry.author do |author|
        author.name(post.username)
      end
    end
  end
end
