FactoryBot.define do
  factory :slideshow do
    name { 'テストスライドショー' }
    description { 'スライドショーの説明' }
    url { 'https://www.google.com/' }
    priority { 1 }
  end
end
