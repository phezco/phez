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
end
