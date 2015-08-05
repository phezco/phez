class Moderation < ActiveRecord::Base
  belongs_to :user
  belongs_to :moderator, class_name: 'User', foreign_key: 'user_id'

  belongs_to :subphez
  belongs_to :moderated_subphez, class_name: 'Subphez', foreign_key: 'subphez_id'
end
