module Admin
  class ProductsController < ApplicationController
    def index
      @q = Product.ransack(params[:q])
      @q.sorts = 'code asc, id desc'
      @products = @q.result(distinct: true).page(params[:page])
    end

    def show
      @product = Product.find(params[:id])
    end

    def new
      @product = Product.new
      fetch_select_data
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to admin_products_path, notice: Product.model_name.human + "「#{@product.name}」を登録しました。"
      else
        fetch_select_data
        render :new
      end
    end

    def edit
      @product = Product.find(params[:id])
      fetch_select_data
    end

    def update
      @product = Product.find(params[:id])
      if @product.update(product_params)
        redirect_to admin_products_path, notice: Product.model_name.human + "「#{@product.name}」を更新しました。"
      else
        fetch_select_data
        render :edit
      end
    end

    def destroy
      product = Product.find_by(id: params[:id])
      if product.nil?
        redirect_index '削除に失敗しました。対象の' + Product.model_name.human + 'は存在しません。'
      elsif product.destroy
        redirect_index Product.model_name.human + "「#{product.name}」を削除しました。"
      else
        redirect_index '削除に失敗しました。' + fetch_errors(product)
      end
    end

    private

    def fetch_select_data
      @select_category_id = Category.all
      @select_tax_item_id = TaxItem.all
    end

    def redirect_index(message)
      redirect_to admin_products_url, notice: message
    end

    def product_params
      params.require(:product).permit(:name, :category_id, :manufacture_name, :code,
                                      :tax_item_id, :sales_price, :regular_price,
                                      :number_of_stocks, :unlimited_stock,
                                      :display_start_datetime_ymd, :display_start_datetime_hn,
                                      :display_end_datetime_ymd, :display_end_datetime_hn,
                                      :description, :search_term, :jan_code,
                                      :status_code).merge(is_divide_by_date_and_time: true)
    end
  end
end
