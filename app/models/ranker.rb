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
    if vote.upvote?
      if vote.created_at > 2.hours.ago
        return 8
      elsif vote.created_at > 4.hours.ago
        return 4
      elsif vote.created_at > 8.hours.ago
        return 2
      else
        return 1
      end
    else
      if vote.created_at > 2.hours.ago
        return -8
      elsif vote.created_at > 4.hours.ago
        return -4
      elsif vote.created_at > 8.hours.ago
        return -2
      else
        return -1
      end
    end
  end

  def self.hot_score_all!
    Subphez.all.each do |subphez|
      hot_score_subphez(subphez)
    end
  end

  def self.hot_score_subphez(subphez)
    i = 0
    top_post = Post.order('points DESC').limit(1).first
    @@max_points_global = top_post.points
    puts "\n\n@@max_points_global = #{@@max_points_global}\n\n"
    subphez.posts.by_points.limit(200).each do |post|
      hot_score = 0
      if i == 0
        # Set the max points to the post in this Subphez with the most points
        @@max_points = post.points
        hot_score = 100
        puts "Setting max_points = #{@@max_points}"
        @@max_points = 1 if @@max_points <= 0
      else
        if post.points
          hot_score = ((post.points.to_f * 100.0) / @@max_points.to_f).to_i
        end
      end
      if post.points
        if @@max_points < @@max_points_global
          # Adjust hot score to the global top points post
          adjusted_hot_score = (hot_score.to_f * (@@max_points.to_f / @@max_points_global.to_f)).to_i
        else
          # Top Post - hot_score is 100
          adjusted_hot_score = hot_score
        end

        # Weight it based on when the post was created
        weight = 1
        if post.created_at > 3.hours.ago
          weight = 1.33
        elsif post.created_at > 6.hours.ago
          weight = 1.25
        elsif post.created_at > 12.hours.ago
          weight = 1.12
        elsif post.created_at > 24.hours.ago
          weight = 1.06
        elsif post.created_at > 48.hours.ago
          weight = 0.95
        else
          weight = 0.9
        end
        adjusted_hot_score = (adjusted_hot_score.to_f * weight).to_i

        puts "#{post.id} :: #{post.title} :: #{post.points} points :: Hot Score :: #{hot_score}\t\tAdjusted Hot Score :: #{adjusted_hot_score}"
        post.update(hot_score: adjusted_hot_score)
      end
      i += 1
    end
  end

end