class ApiProduct
  include ActiveModel::Model
  include Rails.application.routes.url_helpers

  # api/products 検索用の定数
  TYPE_RECOMMEND = 'recommend'.freeze # おすすめ商品
  TYPE_RANKING = 'ranking'.freeze # ランキング
  TYPE_RECENTLY_VIEW = 'recently'.freeze # 最近チェックした商品

  # JSONで取得するデータ種類
  attr_accessor :type

  validates :type, presence: true,
                   inclusion: { in: [TYPE_RECOMMEND, TYPE_RANKING, TYPE_RECENTLY_VIEW] }

  # jsonを生成
  def generate_json
    hash = {}
    hash[:status] = ''
    hash[:message] = ''
    hash[:products] = case type
                      when TYPE_RECOMMEND
                        convert_json(Product.serch_recommend)
                      when TYPE_RANKING
                        convert_json(Product.serch_ranking)
                      when TYPE_RECENTLY_VIEW
                        convert_json(Product.serch_recently_view)
                      else
                        convert_json(nil)
                      end

    if hash[:products].present?
      hash[:status] = Ec::JsonStatus::SUCCESS
      hash[:message] = ''
    else
      hash[:status] = Ec::JsonStatus::FAIL
      hash[:message] = 'no record'
    end

    hash
  end

  def generate_error_json
    hash = {}
    hash[:status] = Ec::JsonStatus::ERROR
    hash[:message] = 'invalid params'
    hash[:error_params] = errors.full_messages.map(&:to_s)
    hash
  end

  class << self
    def init_with_params(params)
      new(params.permit(:type))
    end
  end

  private

  def convert_json(products)
    url = []
    return url if products.nil?

    products.each do |product|
      image_path = product.image.variant(resize: '150x150').processed
      hash_item = {}
      hash_item[:url] = rails_representation_url(image_path, only_path: false, host: 'localhost:3000')
      hash_item[:name] = product.name
      url << hash_item
    end
    url
  end
end
