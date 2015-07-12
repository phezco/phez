class Message < ActiveRecord::Base

  default_scope { order('created_at DESC') } 

  belongs_to :user

  validates :user, :presence => true
  validates :body, :presence => true
  after_create :set_orange

protected

  def set_orange
    user.update(orange: true)
  end

end