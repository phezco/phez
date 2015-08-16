FactoryGirl.define do

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
end
