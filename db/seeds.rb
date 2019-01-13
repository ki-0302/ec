# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TaxClass.find_or_create_by!(id: 1) do |tax_class|
  tax_class.id = 1
  tax_class.name = '消費税８％'
  tax_class.tax_rate = 0.08
end
