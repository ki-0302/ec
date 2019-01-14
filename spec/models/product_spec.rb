require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '追加・更新・削除' do
    let(:product1_name) { 'テスト商品' }
    let(:product2_name) { 'テスト商品２' }
    let(:product1) { FactoryBot.create(:product) }
    let(:product2) { FactoryBot.create(:product, name: product2_name, tax_item: tax_item) }
    let(:tax_item) { FactoryBot.create(:tax_item, name: '食料品', tax_class: tax_class) }
    let(:tax_class) { FactoryBot.create(:tax_class, name: '消費税8%(軽)', tax_rate: 0.08) }

    describe '追加' do
      it '商品が追加できること' do
        expect(product1).to be_valid
        expect(Product.find_by(name: product1_name)).to be_truthy
      end
      it '商品が複数追加できること' do
        expect(product1).to be_valid
        expect(product2).to be_valid
        expect(Product.all.size).to eq 2
        expect(Product.find_by(name: product1_name)).to be_truthy
        expect(Product.find_by(name: product2_name)).to be_truthy
      end
    end
    describe '更新' do
      it '商品が更新できること' do
        expect(product1).to be_valid
        update_product1 = Product.find_by(name: product1_name)
        expect(update_product1).to be_truthy
        update_product1_name = '更新商品'
        update_product1.name = update_product1_name
        update_product1.save
        expect(update_product1).to be_valid
        expect(Product.find_by(name: update_product1_name)).to be_truthy
      end
    end
    describe '削除' do
      it '商品が削除できること' do
        expect(product1).to be_valid
        delete_product1 = Product.find_by(name: product1_name)
        expect(delete_product1).to be_truthy
        delete_product1.destroy
        expect(Product.all.size).to eq 0
      end
    end
  end
  describe 'バリデーション' do
    describe '商品名の確認をおこなう' do
      it '商品名が未入力であれば無効であること' do
      end
      it '商品名が2文字以上でなければ無効であること' do
      end
      it '商品名が40文字以内でなければ無効であること' do
      end
    end
    describe 'カテゴリーの確認をおこなう' do
      it 'カテゴリーが未入力であれば無効であること' do
      end
      it 'カテゴリーがnilを許容すること' do
      end
      it 'カテゴリーマスタに存在しないカテゴリーならば無効であること' do
      end
    end
    describe 'メーカー名の確認をおこなう' do
      it 'メーカー名がnilを許容すること' do
      end
      it 'メーカー名がnilでなく2文字以上でなければ無効であること' do
      end
      it 'メーカー名が40文字以内でなければ無効であること' do
      end
    end
    describe '商品コードの確認をおこなう' do
      it '商品コードがnilを許容すること' do
      end
      it '商品コードが32文字以内でなければ無効であること' do
      end
      it 'すでに存在する商品コードならば無効であること' do
      end
    end
    describe '税率対象品目の確認をおこなう' do
      it '税率対象品目が未入力であれば無効であること' do
      end
      it '税率対象品目に存在しないカテゴリーならば無効であること' do
      end
    end
    describe '販売価格の確認をおこなう' do
      it '販売価格が数値でなければ無効であること' do
      end
      it '販売価格がnilを許容すること' do
      end
      it '販売価格がnilでなく0 〜 99,999,999でなければ無効であること' do
      end
    end
    describe '標準価格の確認をおこなう' do
      it '標準価格が数値でなければ無効であること' do
      end
      it '標準価格がnilを許容すること' do
      end
      it '標準価格がnilでなく0 〜 99,999,999でなければ無効であること' do
      end
    end
    describe '在庫数の確認をおこなう' do
      it '在庫数が数値でなければ無効であること' do
      end
      it '在庫数がnilを許容すること' do
      end
      it '在庫数がnilでなく0 〜 99,999,999でなければ無効であること' do
      end
    end
    describe '在庫数無制限の確認をおこなう' do
      it '在庫数無制限が真偽値でなければ無効であること' do
      end
      it '在庫数無制限がnilを許容しないこと' do
      end
    end
    describe '掲載開始日時の確認をおこなう' do
      it '掲載開始日時が日時でなければ無効であること' do
      end
      it '掲載開始日時がnilを許容すること' do
      end
      it '掲載開始日時が掲載終了日時より小さくなければ無効であること' do
      end
    end
    describe '掲載終了日時の確認をおこなう' do
      it '掲載終了日時が日時でなければ無効であること' do
      end
      it '掲載終了日時がnilを許容すること' do
      end
      it '掲載終了日時が掲載開始日時より大きくなければ無効であること' do
      end
    end
    describe '商品説明の確認をおこなう' do
      it '商品説明がnilを許容すること' do
      end
      it '商品説明が1000文字以内でなければ無効であること' do
      end
    end
    describe '検索文字列の確認をおこなう' do
      it '検索文字列がnilを許容すること' do
      end
      it '検索文字列が40文字以内でなければ無効であること' do
      end
    end
    describe 'JANコードの確認をおこなう' do
      it 'JANコードがnilを許容すること' do
      end
      it 'JANコードが32文字以内でなければ無効であること' do
      end
    end
    describe '商品状態の確認をおこなう' do
      it '商品状態がnilを許容しないこと' do
      end
      it '商品状態が数値でなければ無効であること' do
      end
      it '有効な商品状態でなければ無効であること' do
      end
    end
  end
end
