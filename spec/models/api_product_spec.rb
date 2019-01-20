require 'rails_helper'

RSpec.describe ApiProduct, type: :model do
  describe 'JSON' do
    describe 'データ取得' do
      it 'ハッシュデータが正常に取得できること' do
        product = FactoryBot.create(:product)
        product.image.attach(io: File.open(fixture_path + '/dummy_image.jpg'),
                             filename: 'attachment.jpg', content_type: 'image/jpg')
        expect(product.image).to be_attached

        api_product = ApiProduct.new(
          type: ApiProduct::TYPE_RECOMMEND
        )
        expect(api_product).to be_valid
        hash = api_product.generate_json
        expect(hash.key?(:status)).to eq true
        expect(hash[:status]).to eq Ec::JsonStatus::SUCCESS
      end
    end
  end

  describe 'バリデーション' do
    describe 'データ種類の確認をおこなう' do
      it 'データ種類がnilを許容しないこと' do
        api_product = ApiProduct.new(
          type: nil
        )
        expect(api_product).to_not be_valid
      end
      it 'データ種類が存在しないものであれば無効であること' do
        api_product = ApiProduct.new(
          type: 'recommen'
        )
        api_product.valid?
        expect(api_product.errors[:type]).to include(I18n.t('errors.messages.inclusion'))
      end
      it 'データ種類が用意されたものであれば有効であること' do
        api_product1 = ApiProduct.new(
          type: ApiProduct::TYPE_RECOMMEND
        )
        expect(api_product1).to be_valid
        api_product2 = ApiProduct.new(
          type: ApiProduct::TYPE_RANKING
        )
        expect(api_product2).to be_valid
        api_product3 = ApiProduct.new(
          type: ApiProduct::TYPE_RECENTLY_VIEW
        )
        expect(api_product3).to be_valid
      end
    end
  end
end
