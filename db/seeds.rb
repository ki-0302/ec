# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.find_or_create_by!(name: I18n.t('admin_user.name_default')) do |admin_user|
  admin_user.name = I18n.t('admin_user.name_default')
  admin_user.email = 'admin@example.com'
  admin_user.password = 'Pass000'
end
