require 'factory_girl'

FactoryGirl.define do
  sequence(:random) do |_n|
    (1..10_000).to_a.sample
    # rand(1000)
    # @random ||= (1..1000).to_a.shuffle
    # @random[n]
  end

  factory :user do
    username 'foo'
    password 'phez12345'

    trait :bar do
      username 'bar'
    end

    trait :poster do
      username 'poster'
    end

    trait :admin do
      is_admin true
      username 'admin'
    end
  end

  factory :subphez do
    association :user, factory: :user
    path 'cats'
    title 'Cats Subphez!'
    trait :dogs do
      path 'dogs'
      title 'Dogs Subphez!'
    end
  end

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
