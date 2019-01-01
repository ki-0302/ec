FactoryBot.define do
  factory :admin_user do
    name { 'テストユーザー' }
    email { 'test@example.com' }
    password { 'Password1' }
  end
end
