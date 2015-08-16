FactoryGirl.define do

  factory :post do
    association :user, factory: [:user, :poster]
    association :subphez, factory: :subphez
    vote_total 1
    url 'https://i.imgur.com/xblF4h.jpg'
    title 'MJ popcorn'

    trait :selfpost do
      is_self true
      url nil
      body "This is a self post. It's body can **contain** markdown."
    end
  end
end
