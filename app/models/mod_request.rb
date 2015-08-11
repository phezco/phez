class ModRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :inviting_user, class_name: 'User', foreign_key: 'inviting_user_id'
  belongs_to :subphez
  after_create :deliver_message

  protected

  def deliver_message
    Message.create!(user_id: user.id, title: "Moderator Request for Subphez #{subphez.title}",
                    body: "You have been invited to become a moderator of /p/#{subphez.path} -- To accept, click here: [Approve Moderator Request](/p/#{subphez.path}/approve_modrequest)")
  end
end
