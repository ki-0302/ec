FactoryBot.define do
  factory :category do
    parent_id { nil }
    name { 'テストカテゴリー' }
    display_start_datetime { '2019-01-20 10:10:10' }
    display_end_datetime { '2019-02-02 10:10:10' }
    is_divide_by_date_and_time { false }
  end
end
