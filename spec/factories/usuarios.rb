FactoryBot.define do
  factory :usuario do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { "123456" }
  end
end
