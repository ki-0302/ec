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

GeneralSetting.find_or_create_by!(site_name: I18n.t('general_setting.site_name_default')) do |general_setting|
  general_setting.site_name = I18n.t('general_setting.site_name_default')
  general_setting.postal_code = '100-0000'
  general_setting.region = '東京都'
  general_setting.address1 = '東京市'
  general_setting.address2 = '九条町１−１−１'
  general_setting.address3 = '報瀬ビル５F'
  general_setting.phone_number = '03-0000-0000'
end
