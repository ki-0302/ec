FactoryBot.define do
  factory :general_setting do
    site_name { 'テストサイト' }
    postal_code { '100-0000' }
    region { '東京都' }
    address1 { '東京市' }
    address2 { '玉木町１−１−１' }
    address3 { '報瀬ビル５F' }
    phone_number { '03-0000-0000' }
  end
end
