class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriber, :class_name => 'User', :foreign_key => 'user_id'

  belongs_to :subphez
  belongs_to :subscribed_subphez, :class_name => 'Subphez', :foreign_key => 'subphez_id'

  def self.subscribe!(subphez, user)
    subscription = Subscription.where(subphez_id: subphez.id, user_id: user.id).first
    return false if subscription
    Subscription.create(subphez_id: subphez.id, user_id: user.id)
  end

  def self.unsubscribe!(subphez, user)
    subscription = Subscription.where(subphez_id: subphez.id, user_id: user.id).first
    return false unless subscription
    subscription.destroy
  end

end