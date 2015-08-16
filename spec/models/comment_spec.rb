require "rails_helper"

RSpec.describe Comment, type: :model do

  let(:comment) { FactoryGirl.build :comment }

  subject { comment }

  it { should respond_to(:body) }
  it { should respond_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should have_many(:comment_votes) }

  it { should belong_to (:user) }

  describe "check validations" do
    context "validates presence" do
      it 'is valid with both body and user' do
        comment = FactoryGirl.build_stubbed(:comment)
        comment.valid?
        expect(comment).to be_valid

      end

      it 'is not valid without a body' do
        comment = FactoryGirl.build_stubbed(:comment, body: nil)
        comment.valid?
        expect(comment.errors[:body]).to include("can't be blank")
      end

      it 'is not valid without a user' do
        comment = FactoryGirl.build_stubbed(:comment, user: nil)
        comment.valid?
        expect(comment.errors[:user]).to include("can't be blank")
      end
    end
  end
end
