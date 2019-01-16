require 'rails_helper'

RSpec.describe TaxRate, type: :model do
  describe '追加・更新・削除' do
    let(:tax_rate1_name) { 'テスト税率' }
    let(:tax_rate1) { FactoryBot.create(:tax_rate) }

    describe '追加' do
      it '税率が追加できること' do
        expect(tax_rate1).to be_valid
        expect(TaxRate.find_by(name: tax_rate1_name)).to be_truthy
      end
      it '税率が複数追加できること' do
        expect(tax_rate1).to be_valid

        tax_rate2_name = 'テスト税率2'
        tax_rate2 = FactoryBot.create(:tax_rate, name: tax_rate2_name,
                                                 start_date: '2018-02-02')
        expect(tax_rate2).to be_valid
        expect(TaxRate.find_by(name: tax_rate2_name)).to be_truthy
      end
    end
    describe '更新' do
      it '税率が更新できること' do
        expect(tax_rate1).to be_valid
        update_tax_rate1 = TaxRate.find_by(name: tax_rate1_name)
        expect(update_tax_rate1).to be_truthy
        update_tax_rate1_name = '更新税率'
        update_tax_rate1.name = update_tax_rate1_name
        update_tax_rate1.save
        expect(update_tax_rate1).to be_valid
        expect(TaxRate.find_by(name: update_tax_rate1_name)).to be_truthy
      end
    end
    describe '削除' do
      it '税率が削除できること' do
        expect(tax_rate1).to be_valid
        delete_tax_rate1 = TaxRate.find_by(name: tax_rate1_name)
        expect(delete_tax_rate1).to be_truthy
        delete_tax_rate1.destroy
        expect(TaxRate.all.size).to eq 0
      end
    end
  end

  describe 'バリデーション' do
    describe '名称の確認をおこなう' do
      it '名称が未入力であれば無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, name: '')
        tax_rate.valid?
        expect(tax_rate.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it '名称が2文字以上でなければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, name: 'A' * (TaxRate::MINIMUM_NAME - 1))
        tax_rate.valid?
        expect(tax_rate.errors[:name]).to include(I18n.t('errors.messages.too_short', count: TaxRate::MINIMUM_NAME))
      end
      it '名称が40文字以内でなければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, name: 'A' * (TaxRate::MAXIMUM_NAME + 1))
        tax_rate.valid?
        expect(tax_rate.errors[:name]).to include(I18n.t('errors.messages.too_long', count: TaxRate::MAXIMUM_NAME))
      end
    end
    describe '税率適用開始日の確認をおこなう' do
      it '税率適用開始日がnilであれば無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, start_date: nil)
        expect(tax_rate).to_not be_valid
      end

      it '税率適用開始日が日付けでなければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, start_date: 'あ')
        tax_rate.valid?
        expect(tax_rate.errors[:start_date]).to include(I18n.t('errors.messages.not_a_date'))
      end
      it 'すでに存在する税率適用開始日であれば無効であること' do
        tax_rate = FactoryBot.create(:tax_rate)
        expect(tax_rate).to be_valid
        tax_rate2 = FactoryBot.build(:tax_rate)
        tax_rate2.valid?
        expect(tax_rate2.errors[:start_date]).to include(I18n.t('errors.messages.taken'))
      end
    end
    describe '標準税率の確認をおこなう' do
      it '標準税率が数値でなければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, standard_tax_rate: '１')
        tax_rate.valid?
        expect(tax_rate.errors[:standard_tax_rate]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '標準税率がnilであれば無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, standard_tax_rate: nil)
        expect(tax_rate).to_not be_valid
      end
      it '標準税率が最小値より小さければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, standard_tax_rate: -1)
        tax_rate.valid?
        expect(tax_rate.errors[:standard_tax_rate]).to include(I18n.t('errors.messages.greater_than_or_equal_to',
                                                                      count: TaxRate::MINIMUM_TAX_RATE))
      end
      it '標準税率が最大値より大きければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, standard_tax_rate: TaxRate::MAXIMUM_TAX_RATE + 1)
        tax_rate.valid?
        expect(tax_rate.errors[:standard_tax_rate]).to include(I18n.t('errors.messages.less_than_or_equal_to',
                                                                      count: TaxRate::MAXIMUM_TAX_RATE))
      end
    end
    describe '軽減税率の確認をおこなう' do
      it '軽減税率が数値でなければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, reduced_tax_rate: '１')
        tax_rate.valid?
        expect(tax_rate.errors[:reduced_tax_rate]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '軽減税率がnilを許容すること' do
        tax_rate = FactoryBot.build(:tax_rate, reduced_tax_rate: nil)
        expect(tax_rate).to be_valid
      end
      it '軽減税率が最小値より小さければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, reduced_tax_rate: -1)
        tax_rate.valid?
        expect(tax_rate.errors[:reduced_tax_rate]).to include(I18n.t('errors.messages.greater_than_or_equal_to',
                                                                     count: TaxRate::MINIMUM_TAX_RATE))
      end
      it '軽減税率が最大値より大きければ無効であること' do
        tax_rate = FactoryBot.build(:tax_rate, reduced_tax_rate: TaxRate::MAXIMUM_TAX_RATE + 1)
        tax_rate.valid?
        expect(tax_rate.errors[:reduced_tax_rate]).to include(I18n.t('errors.messages.less_than_or_equal_to',
                                                                     count: TaxRate::MAXIMUM_TAX_RATE))
      end
    end
  end
end
