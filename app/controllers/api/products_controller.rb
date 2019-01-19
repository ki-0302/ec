module Api
  class ProductsController < ApplicationController
    def index
      hash = {} #Hash.new { |h, k| h[k] = {} }
      @products = Product.all

      url = []
      @products.each do |product|
        image_path = product.image.variant(resize: '150x150').processed
        hash_item = {}
        hash_item[:url] = rails_representation_url(image_path, only_path: false)
        url << hash_item
      end

      hash[:products] = url
      hash[:status] = '200'

      render status: 200, json: hash.to_json

    end

    def json_unescape(str)
      str.gsub(/\\b\"/, '')

      # str.gsub(/\\([\\\/]|u[0-9a-fA-F]{4})/) do
      #   ustr = $1
      #   if ustr.starts_with?('u')
      #     [ustr[1..-1].to_i(16)].pack("U")
      #   elsif ustr == '\\'
      #     '\\\\'
      #   else
      #     ustr
      #   end
      # end
    end

  end
end
