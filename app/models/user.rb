class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username] #, :confirmable

  validates :username, uniqueness: true

  has_many :votes, dependent: :destroy

  def email_required?
    false
  end

  def email_changed?
    false
  end

  protected

    def confirmation_required?
      false
    end

end
