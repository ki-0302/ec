require 'rails_helper'

RSpec.describe TaxItem, type: :model do
  describe '追加・更新・削除' do
    let(:tax_item1) { FactoryBot.create(:tax_item, tax_class_id: 3) }

    describe '追加' do
      it '税率対象品目が追加できること' do
        expect(tax_item1).to be_valid
        expect(TaxItem.find_by(name: 'テスト品目')).to be_truthy
      end
      it '税率対象品目が複数追加できること' do
      end
    end
    describe '更新' do
      it '税率対象品目が更新できること' do
      end
    end
    describe '削除' do
      it '税率対象品目が削除できること' do
      end
    end
  end
  describe 'バリデーション' do
    describe '税率対象品目名の確認をおこなう' do
      it '税率対象品目名が未入力であれば無効であること' do
      end
      it '税率対象品目名が2文字以上でなければ無効であること' do
      end
      it '税率対象品目名が40文字以内でなければ無効であること' do
      end
    end
    describe '税率対象品目区分の確認をおこなう' do
      it '税率対象品目区分が未入力であれば無効であること' do
      end
      it '税率対象品目区分が数値でなければ無効であること' do
      end
    end
  end
end
