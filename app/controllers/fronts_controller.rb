class FrontsController < ApplicationController
  layout 'front'

  def show
    name = URI.decode(params[:name]).force_encoding('UTF-8')
    @product = Product.find_by(name: name)
    @product.nil? && redirect_index('対象の' + Product.model_name.human + 'は存在しません。')
  end

  def index
  end

  def redirect_index(message)
    redirect_to :root, notice: message
  end
end
