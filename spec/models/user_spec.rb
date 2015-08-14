require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build :user }

  subject { user }

  it { should validate_presence_of :username }

  it { should have_many(:votes) }
  it { should have_many(:moderations) }
  it { should have_many(:moderated_subphezes) }
  it { should have_many(:messages) }
  it { should have_many(:posts) }
  it { should have_many(:comments) }
  it { should have_many(:subphezes) }
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribed_subphezes) }
  it { should have_many(:transactions) }
  it { should have_many(:oauth_applications)
end
