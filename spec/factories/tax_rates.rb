FactoryBot.define do
  factory :tax_rate do
    name { 'テスト税率' }
    start_date { '2018-01-01' }
    standard_tax_rate { 0.10 }
    reduced_tax_rate { 0.8 }
  end
end
