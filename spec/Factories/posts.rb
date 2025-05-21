FactoryBot.define do
  factory :post do
    title { "Sample Title" }
    body { "Sample Body" }
    association :user

    after(:build) do |post|
      post.tags << build(:tag) if post.tags.blank?
    end
  end
end
