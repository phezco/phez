class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriber, :class_name => 'User', :foreign_key => 'user_id'

  belongs_to :subphez
  belongs_to :subscribed_subphez, :class_name => 'Subphez', :foreign_key => 'subphez_id'

  def self.subscribe!(subphez, user)
    Subscription.create(subphez_id: subphez.id, user_id: user.id)
  end

  def self.unsubscribe!(subphez, user)
    subscription = Subscription.where(subphez_id: subphez.id, user_id: user.id).first
    subscription.destroy if subscription
  end

end