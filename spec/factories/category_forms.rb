FactoryBot.define do
  factory :category_form do
    parent_id { nil }
    name { 'テストカテゴリー' }
    display_start_datetime_ymd { '2019-01-20' }
    display_start_datetime_hn { '10:12:13' }
    display_end_datetime_ymd { '2019-02-21' }
    display_end_datetime_hn { '11:14:17' }
  end
end
