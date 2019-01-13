FactoryBot.define do
  factory :tax_class do
    name { '消費税10%' }
    tax_rate { 0.10 }
  end
end
