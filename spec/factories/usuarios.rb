FactoryBot.define do
  factory :usuario do
    sequence :nome do |n|
      "Usuario #{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { "123456" }
    funcao { :usuario }
  end
end
