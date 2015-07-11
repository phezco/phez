class Ranker

  def self.rank!
    pointify!
    hot_score_all!
  end

  def self.pointify!
    post_hash = {}
    Vote.last_thirtysix_hours.each do |vote|
      if post_hash[vote.post_id]
        post_hash[vote.post_id] += points(vote)
      else
        post_hash[vote.post_id] = points(vote)
      end
    end
    post_hash.each_pair do |post_id, value|
      post = Post.where(id: post_id).first
      if post
        puts "#{post.id} :: #{post.title} :: #{value} points"
        post.update(points: value)
      end
    end
  end

  def self.points(vote)
    if vote.created_at > 3.hours.ago
      return 4
    elsif vote.created_at > 6.hours.ago
      return 3
    elsif vote.created_at > 18.hours.ago
      return 2
    else
      return 1
    end
  end

  def self.hot_score_all!
    Subphez.all.each do |subphez|
      hot_score_subphez(subphez)
    end
  end

  def self.hot_score_subphez(subphez)
    i = 0
    #max_points = 1
    subphez.posts.by_points.limit(200).each do |post|
      hot_score = 0
      if i == 0
        @@max_points = post.points
        hot_score = 100
        puts "Setting max_points = #{post.points}"
      else
        if post.points
          # puts "post.points = #{post.points}"
          # puts "max_points = #{@@max_points}"
          hot_score = ((post.points * 100) / @@max_points).to_i
        end
      end
      if post.points
        puts "#{post.id} :: #{post.title} :: #{post.points} points :: #{hot_score} Hot Score"
        post.update(hot_score: hot_score)
      end
      i += 1
    end
  end

end