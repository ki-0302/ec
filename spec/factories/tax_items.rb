FactoryBot.define do
  factory :tax_item do
    name { 'テスト税率対象品目' }
    association :tax_class
  end
end
