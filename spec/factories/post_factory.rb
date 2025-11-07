FactoryBot.define do
  factory :post do
    sequence(:name) { |n| "Post Number #{n}" }
  end
end
