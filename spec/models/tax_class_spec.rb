require 'rails_helper'

RSpec.describe TaxClass, type: :model do
  describe '追加・更新・削除' do
    let(:tax_class1_name) { '消費税10%' }
    let(:tax_class2_name) { '消費税8%(軽)' }

    let(:tax_class1) { FactoryBot.create(:tax_class) }
    let(:tax_class2) do
      FactoryBot.create(:tax_class, name: tax_class2_name, tax_rate: 0.08)
    end

    describe '追加' do
      it '税区分が追加できること' do
        expect(tax_class1).to be_valid
        expect(TaxClass.find_by(name: tax_class1_name)).to be_truthy
      end
      it '税区分が複数追加できること' do
        expect(tax_class1).to be_valid
        expect(tax_class2).to be_valid
        # 初期データでid:1を登録しているため件数を+1
        expect(TaxClass.all.size).to eq 3
        expect(TaxClass.find_by(name: tax_class1_name)).to be_truthy
        expect(TaxClass.find_by(name: tax_class2_name)).to be_truthy
      end
    end
    describe '更新' do
      it '税区分が更新できること' do
        expect(tax_class1).to be_valid
        update_tax_class1 = TaxClass.find_by(name: tax_class1_name)
        expect(update_tax_class1).to be_truthy
        update_tax_class1_name = '更新税区分'
        update_tax_class1.name = update_tax_class1_name
        update_tax_class1.save
        expect(update_tax_class1).to be_valid
        expect(TaxClass.find_by(name: update_tax_class1_name)).to be_truthy
      end
    end
    describe '削除' do
      it '税区分が削除できること' do
        expect(tax_class1).to be_valid
        delete_tax_class1 = TaxClass.find_by(name: tax_class1_name)
        expect(delete_tax_class1).to be_truthy
        delete_tax_class1_id = delete_tax_class1.id
        delete_tax_class1.destroy
        expect(Category.find_by(id: delete_tax_class1_id)).to be nil
      end
      it '税区分のIDが1であれば削除は無効であること' do
        delete_tax_class1 = TaxClass.find_by(name: I18n.t('tax_class.name_default'))
        expect(delete_tax_class1).to be_truthy
        delete_tax_class1.destroy
        expect(delete_tax_class1.errors[:tax_class]).to include(I18n.t('errors.messages.need_to_leave_at_least_one'))
      end
    end
  end
  describe 'バリデーション' do
    describe '税区分名の確認をおこなう' do
      it '税区分名が未入力であれば無効であること' do
        tax_class = FactoryBot.build(:tax_class, name: '')
        tax_class.valid?
        expect(tax_class.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it '税区分名が2文字以上でなければ無効であること' do
        tax_class = FactoryBot.build(:tax_class, name: 'A')
        tax_class.valid?
        expect(tax_class.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
      end
      it '税区分名が40文字以内でなければ無効であること' do
        tax_class = FactoryBot.build(:tax_class, name: 'A' * 41)
        tax_class.valid?
        expect(tax_class.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
      end
    end
    describe '税率の確認をおこなう' do
      it '税率が未入力であれば無効であること' do
        tax_class = FactoryBot.build(:tax_class, tax_rate: nil)
        tax_class.valid?
        expect(tax_class.errors[:tax_rate]).to include(I18n.t('errors.messages.blank'))
      end
      it '税率が数値でなければ無効であること' do
        tax_class = FactoryBot.build(:tax_class, tax_rate: '１')
        tax_class.valid?
        expect(tax_class.errors[:tax_rate]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '税率が0より小さければ無効であること' do
        tax_class = FactoryBot.build(:tax_class, tax_rate: '-0.01')
        tax_class.valid?
        expect(tax_class.errors[:tax_rate]).to include(I18n.t('errors.messages.greater_than_or_equal_to',
                                                              count: 0))
      end
      it '税率が1より大きければ無効であること' do
        tax_class = FactoryBot.build(:tax_class, tax_rate: '1.1')
        tax_class.valid?
        expect(tax_class.errors[:tax_rate]).to include(I18n.t('errors.messages.less_than_or_equal_to',
                                                              count: 1))
      end
    end
  end
end
