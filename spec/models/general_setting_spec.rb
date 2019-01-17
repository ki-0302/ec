require 'rails_helper'

RSpec.describe GeneralSetting, type: :model do
  describe '追加・更新・削除' do
    let(:general_setting_name) { 'テストサイト' }
    let(:general_setting) { FactoryBot.create(:general_setting, site_name: general_setting_name) }

    describe '追加' do
      it '一般設定が追加できること' do
        expect(general_setting).to be_valid
        expect(GeneralSetting.find_by(site_name: general_setting_name)).to be_truthy
      end
      it '一般設定が複数追加できること' do
        expect(general_setting).to be_valid

        general_setting2_name = 'テスト一般設定2'
        general_setting2 = FactoryBot.create(:general_setting, site_name: general_setting2_name)
        expect(general_setting2).to be_valid
        expect(GeneralSetting.find_by(site_name: general_setting2_name)).to be_truthy
      end
    end
    describe '更新' do
      it '一般設定が更新できること' do
        expect(general_setting).to be_valid
        update_general_setting = GeneralSetting.find_by(site_name: general_setting_name)
        expect(update_general_setting).to be_truthy
        update_general_setting_name = '更新一般設定'
        update_general_setting.site_name = update_general_setting_name
        update_general_setting.save
        expect(update_general_setting).to be_valid
        expect(GeneralSetting.find_by(site_name: update_general_setting_name)).to be_truthy
      end
    end
    describe '削除' do
      it '一般設定が削除できること' do
        expect(general_setting).to be_valid
        delete_general_setting = GeneralSetting.find_by(site_name: general_setting_name)
        expect(delete_general_setting).to be_truthy
        delete_general_setting.destroy
        expect(GeneralSetting.find_by(site_name: general_setting_name)).to_not be_truthy
      end
    end
  end
  describe 'バリデーション' do
    describe 'サイト名の確認をおこなう' do
      it 'サイト名が未入力であれば無効であること' do
        general_setting = FactoryBot.build(:general_setting, site_name: '')
        general_setting.valid?
        expect(general_setting.errors[:site_name]).to include(I18n.t('errors.messages.blank'))
      end
      it 'サイト名が最小文字以上でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, site_name: 'A' * (GeneralSetting::MINIMUM_SITE_NAME - 1))
        general_setting.valid?
        expect(general_setting.errors[:site_name]).to include(I18n.t('errors.messages.too_short',
                                                                     count: GeneralSetting::MINIMUM_SITE_NAME))
      end
      it 'サイト名が最大文字以内でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, site_name: 'A' * (GeneralSetting::MAXIMUM_SITE_NAME + 1))
        general_setting.valid?
        expect(general_setting.errors[:site_name]).to include(I18n.t('errors.messages.too_long',
                                                                     count: GeneralSetting::MAXIMUM_SITE_NAME))
      end
    end
    describe '郵便番号の確認をおこなう' do
      it '郵便番号が未入力を許容すること' do
        general_setting = FactoryBot.build(:general_setting, postal_code: '')
        expect(general_setting).to be_valid
      end
      it '有効な郵便番号でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, postal_code: '3000-0000')
        general_setting.valid?
        expect(general_setting.errors[:postal_code]).to include(I18n.t('errors.messages.invalid'))
      end
    end
    describe '都道府県の確認をおこなう' do
      it '都道府県が未入力を許容すること' do
        general_setting = FactoryBot.build(:general_setting, region: nil)
        expect(general_setting).to be_valid
      end
      it '有効な都道府県でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, region: '茨県')
        general_setting.valid?
        expect(general_setting.errors[:region]).to include(I18n.t('errors.messages.invalid'))
      end
    end
    describe '住所１の確認をおこなう' do
      it '住所１が未入力を許容すること' do
        general_setting = FactoryBot.build(:general_setting, address1: nil)
        expect(general_setting).to be_valid
      end
      it '住所１が最大文字以内でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, address1: 'A' * (GeneralSetting::MAXIMUM_ADDRESS1 + 1))
        general_setting.valid?
        expect(general_setting.errors[:address1]).to include(I18n.t('errors.messages.too_long',
                                                                    count: GeneralSetting::MAXIMUM_ADDRESS1))
      end
    end
    describe '住所２の確認をおこなう' do
      it '住所２が未入力を許容すること' do
        general_setting = FactoryBot.build(:general_setting, address2: nil)
        expect(general_setting).to be_valid
      end
      it '住所２が最大文字以内でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, address2: 'A' * (GeneralSetting::MAXIMUM_ADDRESS2 + 1))
        general_setting.valid?
        expect(general_setting.errors[:address2]).to include(I18n.t('errors.messages.too_long',
                                                                    count: GeneralSetting::MAXIMUM_ADDRESS2))
      end
    end
    describe '住所３の確認をおこなう' do
      it '住所３が未入力を許容すること' do
        general_setting = FactoryBot.build(:general_setting, address3: nil)
        expect(general_setting).to be_valid
      end
      it '住所３が最大文字以内でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, address3: 'A' * (GeneralSetting::MAXIMUM_ADDRESS3 + 1))
        general_setting.valid?
        expect(general_setting.errors[:address3]).to include(I18n.t('errors.messages.too_long',
                                                                    count: GeneralSetting::MAXIMUM_ADDRESS3))
      end
    end
    describe '電話番号の確認をおこなう' do
      it '電話番号が未入力を許容すること' do
        general_setting = FactoryBot.build(:general_setting, phone_number: nil)
        expect(general_setting).to be_valid
      end
      it '有効な電話番号でなければ無効であること' do
        general_setting = FactoryBot.build(:general_setting, phone_number: '03-333-2222')
        general_setting.valid?
        expect(general_setting.errors[:phone_number]).to include(I18n.t('errors.messages.invalid'))
      end
    end
  end
end
