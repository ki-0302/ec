FactoryBot.define do
  factory :admin_user do
    user_name { 'テストユーザー' }
    email { 'test@example.com' }
    password { 'Password1' }
  end
end
