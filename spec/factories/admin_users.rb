FactoryBot.define do
  factory :admin_user do
    user_name { "テストユーザー" }
    email { "test@example.com" }
    password { "password" }
  end
end
