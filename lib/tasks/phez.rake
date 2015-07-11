namespace :phez do

  desc "Create dummy phez data"
  task :dummy => :environment do
    user_prefix = 'user'
    user_count = 100
    password = 'phez12345'
    users = []
    1.upto(user_count) do |i|
      #puts i
      u = User.where(username: "#{user_prefix}#{i}").first
      unless u
        u = User.create!(username: "#{user_prefix}#{i}", password: password)
        puts "Created User: #{u.inspect}"
      end
      users << u
    end

    subphez_prefix = "subphez"
    subphez_count = 3
    subphezes = []
    1.upto(subphez_count) do |i|
      s = Subphez.where(path: "#{subphez_prefix}#{i}").first
      unless s
        s = Subphez.create!(user_id: users.sample.id, path: "#{subphez_prefix}#{i}", title: "#{subphez_prefix.titleize} #{i}")
      end
      subphezes << s
    end
    post_data = {'Bitcoin' => 'Bitcoin',
             'Satoshi_Nakamoto' => 'Satoshi Nakamoto',
             'First_Amendment_to_the_United_States_Constitution' => 'First Amendment',
             'Peer-to-peer' => 'Peer to Peer',
             'Edward_Snowden' => 'Edward Snowden',
             'Mahatma_Gandhi' => 'Gandhi',
             'Civilization_(video_game)' => 'Sid Meiers Civilization',
             'Minecraft' => 'Minecraft',
             'The_Big_Lebowski' => 'The Big Lebowski',
             'The_Matrix' => 'What is the Matrix?',
             'Nicolas_Cage' => 'Nicolas Cage',
             'Rampart_(film)' => 'Rampart',
             'Tupac_Shakur' => '2Pac'}

    posts = []
    post_data.each_pair do |key, value|
      url = "https://en.wikipedia.org/wiki/#{key}"
      p = Post.where(url: url).first
      p.destroy if p
      p = Post.create!(url: url, title: value, user_id: users.sample.id, subphez_id: subphezes.sample.id)

      p.created_at = (rand(12) + 12).hours.ago
      p.save
      puts "Created Post: #{p.inspect}"
      posts << p
    end

    posts.each do |post|
      to_vote = (rand( user_count / 2 ) + (user_count.to_f * 0.25).to_i).to_i
      to_vote.times do
        u = users.sample
        v = Vote.upvote(u, post)
        v.created_at = (rand(36) + 1).hours.ago
        v.save
        puts "\tUpvoted #{post.title} by #{u.username}: #{v.inspect}"
      end

      to_downvote = rand( user_count / 3 ).to_i
      to_downvote.times do
        u = users.sample
        v = Vote.downvote(u, post)
        v.created_at = (rand(36) + 1).hours.ago
        v.save
        puts "\tDownvoted #{post.title} by #{u.username}: #{v.inspect}"
      end

    end

  end

end
