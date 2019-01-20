module Api
  class ProductsController < ApplicationController
    include Rails.application.routes.url_helpers
    def index
      api_product = ApiProduct.init_with_params(params)
      return render json: api_product.generate_error_json if api_product.invalid?

      render json: api_product.generate_json
    end

    private

    def products_params
      params.permit(:name, :type)
    end
  end
end
