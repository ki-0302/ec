require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:tax_item1) { FactoryBot.create(:tax_item, name: '食料品', tax_class: tax_class1) }
  let(:tax_class1) { FactoryBot.create(:tax_class, name: '消費税8%(軽)', tax_rate: 0.08) }
  let(:tax_item2) { FactoryBot.create(:tax_item, name: '酒類', tax_class: tax_class2) }
  let(:tax_class2) { FactoryBot.create(:tax_class, name: '消費税10%', tax_rate: 0.1) }

  describe '追加・更新・削除' do
    let(:product1_name) { 'テスト商品' }
    let(:product2_name) { 'テスト商品２' }
    let(:product1) { FactoryBot.create(:product, name: product1_name) }
    let(:product2) { FactoryBot.create(:product, name: product2_name, tax_item: tax_item1) }

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
        product = FactoryBot.build(:product, name: 'A' * (Product::MINIMUM_NAME - 1))
        product.valid?
        expect(product.errors[:name]).to include(I18n.t('errors.messages.too_short', count: Product::MINIMUM_NAME))
      end
      it '商品名が40文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, name: 'A' * (Product::MAXIMUM_NAME + 1))
        product.valid?
        expect(product.errors[:name]).to include(I18n.t('errors.messages.too_long', count: Product::MAXIMUM_NAME))
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
        product = FactoryBot.build(:product, manufacture_name: 'A' * (Product::MAXIMUM_MANUFACTURE_NAME + 1))
        product.valid?
        expect(product.errors[:manufacture_name]).to include(I18n.t('errors.messages.too_long',
                                                                    count: Product::MAXIMUM_MANUFACTURE_NAME))
      end
    end
    describe '商品コードの確認をおこなう' do
      it '商品コードがnilを許容すること' do
        product = FactoryBot.build(:product, code: nil)
        expect(product).to be_valid
      end
      it '商品コードが32文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, code: 'A' * (Product::MAXIMUM_CODE + 1))
        product.valid?
        expect(product.errors[:code]).to include(I18n.t('errors.messages.too_long',
                                                        count: Product::MAXIMUM_CODE))
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
      it '掲載開始日時がnilを許容すること' do
        product = FactoryBot.build(:product, display_end_datetime: nil)
        expect(product).to be_valid
      end

      it '掲載開始日時がnilでも日時でもなければ無効であること' do
        product = FactoryBot.build(:product, display_start_datetime: '2018-01-01 10:20',
                                             display_end_datetime: '2018-01-02 10:20')
        product.valid?
        expect(product.errors[:display_start_datetime]).to_not include(I18n.t('errors.messages.not_a_datetime'))
        product2 = FactoryBot.build(:product, display_start_datetime: '2018-01-01 77:33',
                                              display_end_datetime: '2018-01-02 10:20',
                                              tax_item: tax_item1)
        product2.valid?
        expect(product2.errors[:display_start_datetime]).to include(I18n.t('errors.messages.not_a_datetime'))
      end
      it '掲載開始日時が掲載終了日時より大きい場合無効であること' do
        product = FactoryBot.build(:product, display_start_datetime: '2019-01-01 00:02:00',
                                             display_end_datetime: '2019-01-01 00:01:00')
        product.valid?
        comparison = Product.human_attribute_name(:display_start_datetime)
        expect(product.errors[:display_end_datetime]).to include(I18n.t('errors.messages.greater_than',
                                                                        count: comparison))
      end
    end
    describe '掲載終了日時の確認をおこなう' do
      it '掲載終了日時がnilを許容すること' do
        product = FactoryBot.build(:product, display_end_datetime: nil)
        expect(product).to be_valid
      end
      it '掲載終了日時がnilでも日時でなければ無効であること' do
        product = FactoryBot.build(:product, display_start_datetime: '2018-01-01 10:20',
                                             display_end_datetime: '2018-01-02 10:20')
        product.valid?
        expect(product.errors[:display_end_datetime]).to_not include(I18n.t('errors.messages.not_a_datetime'))
        product2 = FactoryBot.build(:product, display_start_datetime: '2018-01-01 10:33',
                                              display_end_datetime: '2018-01-02 77:20',
                                              tax_item: tax_item1)
        product2.valid?
        expect(product2.errors[:display_end_datetime]).to include(I18n.t('errors.messages.not_a_datetime'))
      end
    end
    describe '商品説明の確認をおこなう' do
      it '商品説明がnilを許容すること' do
        product = FactoryBot.build(:product, description: nil)
        expect(product).to be_valid
      end
      it '商品説明が1000文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, description: 'A' * (Product::MAXIMUM_DESCRIPTION + 1))
        product.valid?
        expect(product.errors[:description]).to include(I18n.t('errors.messages.too_long',
                                                               count: Product::MAXIMUM_DESCRIPTION))
      end
    end
    describe '検索文字列の確認をおこなう' do
      it '検索文字列がnilを許容すること' do
        product = FactoryBot.build(:product, search_term: nil)
        expect(product).to be_valid
      end
      it '検索文字列が40文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, search_term: 'A' * (Product::MAXIMUM_SEARCH_TERM + 1))
        product.valid?
        expect(product.errors[:search_term]).to include(I18n.t('errors.messages.too_long',
                                                               count: Product::MAXIMUM_SEARCH_TERM))
      end
    end
    describe 'JANコードの確認をおこなう' do
      it 'JANコードがnilを許容すること' do
        product = FactoryBot.build(:product, jan_code: nil)
        expect(product).to be_valid
      end
      it 'JANコードが32文字以内でなければ無効であること' do
        product = FactoryBot.build(:product, jan_code: 'A' * (Product::MAXIMUM_JAN_CODE + 1))
        product.valid?
        expect(product.errors[:jan_code]).to include(I18n.t('errors.messages.too_long',
                                                            count: Product::MAXIMUM_JAN_CODE))
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

  describe '追加・更新・削除　日・時に別れた場合' do
    let(:product1_name) { 'テスト商品' }
    let(:product2_name) { 'テスト商品２' }
    let(:product1) do
      FactoryBot.create(:product, name: product1_name,
                                  display_start_datetime_ymd: '2019-01-20',
                                  display_start_datetime_hn: '10:00',
                                  display_end_datetime_ymd: '2019-01-31',
                                  display_end_datetime_hn: '12:22',
                                  is_divide_by_date_and_time: true)
    end
    let(:product2) do
      FactoryBot.create(:product, name: product2_name,
                                  display_start_datetime_ymd: '2019-01-20',
                                  display_start_datetime_hn: '10:00',
                                  display_end_datetime_ymd: '2019-01-31',
                                  display_end_datetime_hn: '12:22',
                                  is_divide_by_date_and_time: true,
                                  tax_item: tax_item1)
    end

    describe '追加' do
      it '商品が追加できること' do
        expect(product1).to be_valid
        expect(Product.find_by(name: product1_name)).to be_truthy
      end
      it '商品が複数追加できること' do
        expect(product1).to be_valid
        expect(product2).to be_valid
        expect(Product.find_by(name: product2_name)).to be_truthy
      end
    end

    describe '更新' do
      it '商品が更新できること' do
        expect(product1).to be_valid
        update_product1 = Product.find_by(name: product1_name)
        expect(update_product1).to be_truthy
        update_product1.name = '更新カテゴリー'
        update_product1.is_divide_by_date_and_time = true
        update_product1.save
        expect(update_product1).to be_valid
        expect(Product.find_by(name: '更新カテゴリー')).to be_truthy
      end
    end
    describe '削除' do
      it 'カテゴリーが削除できること' do
        expect(product1).to be_valid
        delete_product1 = Product.find_by(name: product1_name)
        expect(delete_product1).to be_truthy
        delete_product1.destroy
        expect(Product.all.size).to eq 0
      end
    end
  end

  describe 'バリデーション 日・時に別れた場合' do
    describe '掲載開始日時の確認をおこなう' do
      it '掲載開始日・時がnilを許容すること' do
        product = FactoryBot.build(:product, display_start_datetime_ymd: nil,
                                             display_start_datetime_hn: nil,
                                             is_divide_by_date_and_time: true)
        expect(product).to be_valid
      end
      it '掲載開始日・時がnilでも日・時でもなければ無効であること' do
        product1 = FactoryBot.build(:product, display_start_datetime_ymd: '2018-31-01',
                                              display_start_datetime_hn: '20:11',
                                              display_end_datetime_ymd: '2018-01-02',
                                              display_end_datetime_hn: '10:20',
                                              is_divide_by_date_and_time: true,
                                              tax_item: tax_item1)
        product1.valid?
        expect(product1.errors[:display_start_datetime_ymd]).to include(I18n.t('errors.messages.not_a_date'))
        product2 = FactoryBot.build(:product, display_start_datetime_ymd: '2018-01-01',
                                              display_start_datetime_hn: '30:70',
                                              display_end_datetime_ymd: '2018-01-02',
                                              display_end_datetime_hn: '10:20',
                                              is_divide_by_date_and_time: true,
                                              tax_item: tax_item2)
        product2.valid?
        expect(product2.errors[:display_start_datetime_hn]).to include(I18n.t('errors.messages.not_a_time'))
      end
      it '掲載開始日時が掲載終了日時より大きい場合無効であること' do
        product = FactoryBot.build(:product, display_start_datetime_ymd: '2018-01-03',
                                             display_start_datetime_hn: '20:20',
                                             display_end_datetime_ymd: '2018-01-02',
                                             display_end_datetime_hn: '10:20',
                                             is_divide_by_date_and_time: true)
        product.valid?
        comparison = Product.human_attribute_name(:display_start_datetime)
        expect(product.errors[:display_end_datetime]).to include(I18n.t('errors.messages.greater_than',
                                                                        count: comparison))
      end
    end
    describe '掲載終了日時の確認をおこなう' do
      it '掲載終了日時がnilを許容すること' do
        product = FactoryBot.build(:product, display_end_datetime_ymd: nil,
                                             display_end_datetime_hn: nil,
                                             is_divide_by_date_and_time: true)
        expect(product).to be_valid
      end
      it '掲載終了日時がnilでも日時でなければ無効であること' do
        product1 = FactoryBot.build(:product, display_start_datetime_ymd: '2018-31-01',
                                              display_start_datetime_hn: '20:11',
                                              display_end_datetime_ymd: '2018-31-02',
                                              display_end_datetime_hn: '10:20',
                                              is_divide_by_date_and_time: true,
                                              tax_item: tax_item1)
        product1.valid?
        expect(product1.errors[:display_end_datetime_ymd]).to include(I18n.t('errors.messages.not_a_date'))
        product2 = FactoryBot.build(:product, display_start_datetime_ymd: '2018-01-01',
                                              display_start_datetime_hn: '11:22',
                                              display_end_datetime_ymd: '2018-01-02',
                                              display_end_datetime_hn: '30:20',
                                              is_divide_by_date_and_time: true,
                                              tax_item: tax_item2)
        product2.valid?
        expect(product2.errors[:display_end_datetime_hn]).to include(I18n.t('errors.messages.not_a_time'))
      end
    end
  end
end
