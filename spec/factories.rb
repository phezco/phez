require 'factory_girl'

FactoryGirl.define do

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

    trait :subphez_creator do
      username 'subphezCreator'
    end

    trait :subphez_creator_two do
      username 'subphezCreator2'
    end

  end

  factory :subphez do
    association :user, factory: [:user, :subphez_creator]
    path 'cats'
    title 'Cats Subphez!'
    trait :dogs do
      path 'dogs'
      title 'Dogs Subphez!'
      association :user, factory: [:user, :subphez_creator_two]
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

