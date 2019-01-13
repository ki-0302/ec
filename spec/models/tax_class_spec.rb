require 'rails_helper'

RSpec.describe TaxClass, type: :model do
  describe '追加・更新・削除' do
    let(:tax_class1_name) { '消費税１０％' }
    let(:tax_class2_name) { '消費税８％(軽)' }

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
        delete_tax_class1 = TaxClass.find_by(id: TaxClass::DEFAULT_TAX_CLASS_ID)
        expect(delete_tax_class1).to be_truthy
        delete_tax_class1.destroy
        expect(delete_tax_class1.errors[:id]).to include(I18n.t('errors.messages.can_not_be_deleted',
                                                                target: delete_tax_class1.id))
      end
    end
  end
  describe 'バリデーション' do
    describe '税区分名の確認をおこなう' do
      it '税区分名が未入力であれば無効であること' do
      end
      it '税区分名が2文字以上でなければ無効であること' do
      end
      it '税区分名が40文字以内でなければ無効であること' do
      end
    end
    describe '税率の確認をおこなう' do
      it '税率が未入力であれば無効であること' do
      end
      it '税率が数値でなければ無効であること' do
      end
    end
  end
end
