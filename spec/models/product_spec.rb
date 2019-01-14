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
        product = FactoryBot.build(:product, name: '')
        product.valid?
        expect(product.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it '商品名が2文字以上でなければ無効であること' do
        product = FactoryBot.build(:product, name: 'A')
        product.valid?
        expect(product.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
      end
      it '商品名が40文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, name: 'A' * 41)
        product.valid?
        expect(product.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
      end
    end
    describe 'カテゴリーの確認をおこなう' do
      it 'カテゴリーがnilを許容すること' do
        product = FactoryBot.build(:product, category: nil)
        expect(product).to be_valid
      end
      it 'カテゴリーマスタに存在しないカテゴリーならば無効であること' do
        expect do
          product = FactoryBot.create(:product)
          expect(product).to be_truthy
          product.category_id += 1
          product.save
        end.to raise_error(ActiveRecord::InvalidForeignKey)
      end
    end
    describe 'メーカー名の確認をおこなう' do
      it 'メーカー名がnilを許容すること' do
        product = FactoryBot.build(:product, manufacture_name: nil)
        expect(product).to be_valid
      end
      it 'メーカー名が40文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, manufacture_name: 'A' * 41)
        product.valid?
        expect(product.errors[:manufacture_name]).to include(I18n.t('errors.messages.too_long',
                                                                    count: 40))
      end
    end
    describe '商品コードの確認をおこなう' do
      it '商品コードがnilを許容すること' do
        product = FactoryBot.build(:product, code: nil)
        expect(product).to be_valid
      end
      it '商品コードが32文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, code: 'A' * 33)
        product.valid?
        expect(product.errors[:code]).to include(I18n.t('errors.messages.too_long',
                                                        count: 32))
      end
    end
    describe '税率対象品目の確認をおこなう' do
      it '税率対象品目が未入力であれば無効であること' do
        product = FactoryBot.build(:product, tax_item: nil)
        expect(product).to_not be_valid
      end
      it '税率対象品目に存在しない税率対象品目ならば無効であること' do
        product = FactoryBot.create(:product)
        expect(product).to be_truthy
        product.tax_item_id += 1
        product.save
        expect(product).to_not be_valid
      end
    end
    describe '販売価格の確認をおこなう' do
      it '販売価格が数値でなければ無効であること' do
        product = FactoryBot.build(:product, sales_price: '１')
        product.valid?
        expect(product.errors[:sales_price]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '販売価格がnilを許容すること' do
        product = FactoryBot.build(:product, sales_price: nil)
        expect(product).to be_valid
      end
      it '販売価格が0より小さければ無効であること' do
        product = FactoryBot.build(:product, sales_price: -1)
        product.valid?
        expect(product.errors[:sales_price]).to include(I18n.t('errors.messages.greater_than_or_equal_to',
                                                               count: 0))
      end
      it '販売価格が99,999,999より大きければ無効であること' do
        product = FactoryBot.build(:product, sales_price: Product::MAXIMUM_SALES_PRICE + 1)
        product.valid?
        expect(product.errors[:sales_price]).to include(I18n.t('errors.messages.less_than_or_equal_to',
                                                               count: Product::MAXIMUM_SALES_PRICE))
      end
    end
    describe '標準価格の確認をおこなう' do
      it '標準価格が数値でなければ無効であること' do
        product = FactoryBot.build(:product, regular_price: '１')
        product.valid?
        expect(product.errors[:regular_price]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '標準価格がnilを許容すること' do
        product = FactoryBot.build(:product, regular_price: nil)
        expect(product).to be_valid
      end
      it '標準価格が0より小さければ無効であること' do
        product = FactoryBot.build(:product, regular_price: -1)
        product.valid?
        expect(product.errors[:regular_price]).to include(I18n.t('errors.messages.greater_than_or_equal_to',
                                                                 count: 0))
      end
      it '標準価格が99,999,999より大きければ無効であること' do
        product = FactoryBot.build(:product, regular_price: Product::MAXIMUM_REGULAR_PRICE + 1)
        product.valid?
        expect(product.errors[:regular_price]).to include(I18n.t('errors.messages.less_than_or_equal_to',
                                                                 count: Product::MAXIMUM_REGULAR_PRICE))
      end
    end
    describe '在庫数の確認をおこなう' do
      it '在庫数が数値でなければ無効であること' do
        product = FactoryBot.build(:product, number_of_stocks: '１')
        product.valid?
        expect(product.errors[:number_of_stocks]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '在庫数がnilを許容すること' do
        product = FactoryBot.build(:product, number_of_stocks: nil)
        expect(product).to be_valid
      end
      it '在庫数が0より小さければ無効であること' do
        product = FactoryBot.build(:product, number_of_stocks: -1)
        product.valid?
        expect(product.errors[:number_of_stocks]).to include(I18n.t('errors.messages.greater_than_or_equal_to',
                                                                    count: 0))
      end
      it '在庫数が99,999,999より大きければ無効であること' do
        product = FactoryBot.build(:product, number_of_stocks: Product::MAXIMUM_NUMBER_OF_STOCKS + 1)
        product.valid?
        expect(product.errors[:number_of_stocks]).to include(I18n.t('errors.messages.less_than_or_equal_to',
                                                                    count: Product::MAXIMUM_NUMBER_OF_STOCKS))
      end
    end
    describe '在庫数無制限の確認をおこなう' do
      # 自動でbooleanに変換されるため、trueとfalseのみチェック
      it '在庫数無制限に true が設定できること' do
        product = FactoryBot.build(:product, unlimited_stock: true)
        expect(product).to be_valid
        expect(product.unlimited_stock).to eq true
      end
      it '在庫数無制限に false が設定できること' do
        product = FactoryBot.build(:product, unlimited_stock: false)
        expect(product).to be_valid
        expect(product.unlimited_stock).to eq false
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
        product = FactoryBot.build(:product, description: nil)
        expect(product).to be_valid
      end
      it '商品説明が1000文字以内でなければ無効であること' do
      end
    end
    describe '検索文字列の確認をおこなう' do
      it '検索文字列がnilを許容すること' do
        product = FactoryBot.build(:product, search_term: nil)
        expect(product).to be_valid
      end
      it '検索文字列が40文字以内でなければ無効であること' do
      end
    end
    describe 'JANコードの確認をおこなう' do
      it 'JANコードがnilを許容すること' do
        product = FactoryBot.build(:product, jan_code: nil)
        expect(product).to be_valid
      end
      it 'JANコードが32文字以内でなければ無効であること' do
      end
    end
    describe '商品状態の確認をおこなう' do
      it '商品状態がnilを許容しないこと' do
        product = FactoryBot.build(:product, status_code: nil)
        expect(product).to_not be_valid
      end
      it '商品状態が数値でなければ無効であること' do
        product = FactoryBot.build(:product, status_code: '１')
        product.valid?
        expect(product.errors[:status_code]).to include(I18n.t('errors.messages.not_a_number'))
      end
      it '有効な商品状態でなければ無効であること' do
        product = FactoryBot.build(:product, status_code: 999)
        product.valid?
        expect(product.errors[:status_code]).to include(I18n.t('errors.messages.inclusion'))
      end
    end
  end
end
