FactoryBot.define do
  factory :item do
    name { "" }
    category_id { "" }
    code { "" }
    taxitem_id { "" }
    sales_price { "" }
    regular_price { "" }
    number_of_stocks { "" }
    unlimited_stock { "" }
    display_start_date { "" }
    display_end_date { "" }
    description { "" }
    search_term { "" }
    jan_code { "" }
    status { 1 }
  end
end
