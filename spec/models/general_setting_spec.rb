require 'rails_helper'

RSpec.describe GeneralSetting, type: :model do
  describe '追加・更新・削除' do
    let(:general_setting_name) { 'テストサイト' }
    let(:general_setting) { FactoryBot.create(:general_setting, name: general_setting_name) }

    describe '追加' do
      it '一般設定が追加できること' do
        expect(general_setting).to be_valid
        expect(GeneralSetting.find_by(name: general_setting_name)).to be_truthy
      end
      it '一般設定が複数追加できること' do
        expect(general_setting).to be_valid

        general_setting2_name = 'テスト一般設定2'
        general_setting2 = FactoryBot.create(:general_setting, name: general_setting2_name)
        expect(general_setting2).to be_valid
        expect(GeneralSetting.find_by(name: general_setting2_name)).to be_truthy
      end
    end
    describe '更新' do
      it '一般設定が更新できること' do
        expect(general_setting).to be_valid
        update_general_setting = GeneralSetting.find_by(name: general_setting_name)
        expect(update_general_setting).to be_truthy
        update_general_setting_name = '更新一般設定'
        update_general_setting.name = update_general_setting_name
        update_general_setting.save
        expect(update_general_setting).to be_valid
        expect(GeneralSetting.find_by(name: update_general_setting_name)).to be_truthy
      end
    end
    describe '削除' do
      it '一般設定が削除できること' do
        expect(general_setting).to be_valid
        delete_general_setting = GeneralSetting.find_by(name: general_setting_name)
        expect(delete_general_setting).to be_truthy
        delete_general_setting.destroy
        expect(GeneralSetting.all.size).to eq 0
      end
    end
  end
end
