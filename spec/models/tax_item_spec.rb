require 'rails_helper'

RSpec.describe TaxItem, type: :model do
  describe '追加・更新・削除' do
    let(:tax_item1_name) { 'テスト税率対象品目' }
    let(:tax_item2_name) { 'テスト税率対象品目２' }

    let(:tax_item1) { FactoryBot.create(:tax_item) }
    let(:tax_item2) do
      FactoryBot.create(:tax_item, name: tax_item2_name,
                                   tax_class: FactoryBot.create(:tax_class, name: '消費税8%(軽)'))
    end

    describe '追加' do
      it '税率対象品目が追加できること' do
        expect(tax_item1).to be_valid
        expect(TaxItem.find_by(name: tax_item1_name)).to be_truthy
      end
      it '税率対象品目が複数追加できること' do
        expect(tax_item1).to be_valid
        expect(tax_item2).to be_valid
        expect(TaxItem.all.size).to eq 2
        expect(TaxItem.find_by(name: tax_item1_name)).to be_truthy
        expect(TaxItem.find_by(name: tax_item2_name)).to be_truthy
      end
    end
    describe '更新' do
      it '税率対象品目が更新できること' do
        expect(tax_item1).to be_valid
        update_tax_item1 = TaxItem.find_by(name: tax_item1_name)
        expect(update_tax_item1).to be_truthy
        update_tax_item1_name = '更新税区分'
        update_tax_item1.name = update_tax_item1_name
        update_tax_item1.save
        expect(update_tax_item1).to be_valid
        expect(TaxItem.find_by(name: update_tax_item1_name)).to be_truthy
      end
    end
    describe '削除' do
      it '税率対象品目が削除できること' do
        expect(tax_item1).to be_valid
        delete_tax_item1 = TaxItem.find_by(name: tax_item1_name)
        expect(delete_tax_item1).to be_truthy
        delete_tax_item1.destroy
        expect(TaxItem.all.size).to eq 0
      end
    end
  end
  describe 'バリデーション' do
    describe '税率対象品目名の確認をおこなう' do
      it '税率対象品目名が未入力であれば無効であること' do
        tax_item = FactoryBot.build(:tax_item, name: '')
        tax_item.valid?
        expect(tax_item.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it '税率対象品目名が2文字以上でなければ無効であること' do
        tax_item = FactoryBot.build(:tax_item, name: 'A')
        tax_item.valid?
        expect(tax_item.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
      end
      it '税率対象品目名が40文字以内でなければ無効であること' do
        tax_item = FactoryBot.build(:tax_item, name: 'A' * 41)
        tax_item.valid?
        expect(tax_item.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
      end
    end
    describe '税率対象品目区分の確認をおこなう' do
      it '税率対象品目区分が未入力であれば無効であること' do
        tax_item = FactoryBot.build(:tax_item, tax_class_id: nil)
        tax_item.valid?
        expect(tax_item.errors[:tax_class_id]).to include(I18n.t('errors.messages.blank'))
      end
      it '税率対象品目区分が数値でなければ無効であること' do
        tax_item = FactoryBot.build(:tax_item, tax_class_id: '１')
        tax_item.valid?
        expect(tax_item.errors[:tax_class_id]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '税率対象品目区分に存在しないidを入力すると無効であること' do
        tax_item = FactoryBot.create(:tax_item)
        expect(tax_item).to be_truthy
        tax_item.tax_class_id += 1
        tax_item.save
        expect(tax_item).to_not be_valid
      end
    end
  end
end
