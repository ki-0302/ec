module Admin
  class TaxItemsController < ApplicationController
    def index
      @q = TaxItem.ransack(params[:q])
      @q.sorts = 'id desc'
      @tax_items = @q.result(distinct: true).page(params[:page])
    end

    def show
      @tax_item = TaxItem.find(params[:id])
    end

    def new
      @tax_item = TaxItem.new
      fetch_select_tax_class
    end

    def create
      @tax_item = TaxItem.new(tax_item_params)

      if @tax_item.save
        redirect_to admin_tax_items_path, notice: TaxItem.model_name.human + "「#{@tax_item.name}」を登録しました。"
      else
        fetch_select_tax_class
        render :new
      end
    end

    def edit
      @tax_item = TaxItem.find(params[:id])
      fetch_select_tax_class
    end

    def update
      @tax_item = TaxItem.find(params[:id])
      if @tax_item.update(tax_item_params)
        redirect_to admin_tax_items_path, notice: TaxItem.model_name.human + "「#{@tax_item.name}」を更新しました。"
      else
        fetch_select_tax_class
        render :edit
      end
    end

    def destroy
      tax_item = TaxItem.find_by(id: params[:id])
      if tax_item.nil?
        redirect_index '削除に失敗しました。対象の' + TaxItem.model_name.human + 'は存在しません。'
      elsif tax_item.destroy
        redirect_index TaxItem.model_name.human + "「#{tax_item.name}」を削除しました。"
      else
        redirect_index '削除に失敗しました。' + fetch_errors(tax_item)
      end
    end

    private

    def fetch_select_tax_class
      @select_tax_class_id = TaxClass.all
    end

    def redirect_index(message)
      redirect_to admin_tax_items_url, notice: message
    end

    def tax_item_params
      params.require(:tax_item).permit(:name, :tax_class_id)
    end
  end
end
