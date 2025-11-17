FactoryBot.define do
  factory :comment do
    association :post
    sequence(:content) { |n| "Comment Number #{n}" }
  end
end
