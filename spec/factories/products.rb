FactoryBot.define do
  factory :product do
    name { 'テスト商品' }
    association :category
    manufacture_name { 'テストメーカー' }
    code { 'ABC-001' }
    association :tax_item
    sales_price { 5980 }
    regular_price { 6200 }
    number_of_stocks { 100 }
    unlimited_stock { false }
    display_start_datetime { '2019-01-20 12:00:00' }
    display_end_datetime { '2019-06-20 12:00:00' }
    description { '商品説明です' }
    search_term { '冬 ライト' }
    jan_code { '4512345678901' }
    status { 0 }
    is_divide_by_date_and_time { false }
  end
end
