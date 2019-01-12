FactoryBot.define do
  factory :tax_class do
    name { '消費税８％' }
    tax_rate { 0.08 }
  end
end
