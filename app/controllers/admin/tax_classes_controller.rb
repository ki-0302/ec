module Admin
  class TaxClassesController < ApplicationController
    def index
      @q = TaxClass.ransack(params[:q])
      @q.sorts = 'id desc'
      @tax_classes = @q.result(distinct: true).page(params[:page])
    end

    def show
      @tax_class = TaxClass.find(params[:id])
    end

    def new
      @tax_class = TaxClass.new
    end

    def create
      @tax_class = TaxClass.new(tax_class_params)

      if @tax_class.save
        redirect_to admin_tax_classes_path, notice: TaxClass.model_name.human + "「#{@tax_class.name}」を登録しました。"
      else
        render :new
      end
    end

    def edit
      @tax_class = TaxClass.find(params[:id])
    end

    def update
      @tax_class = TaxClass.find(params[:id])
      if @tax_class.update(tax_class_params)
        redirect_to admin_tax_classes_path, notice: TaxClass.model_name.human + "「#{@tax_class.name}」を更新しました。"
      else
        render :edit
      end
    end

    def destroy
      tax_class = TaxClass.find_by(id: params[:id])
      if tax_class.nil?
        redirect_index '削除に失敗しました。対象の' + TaxClass.model_name.human + 'は存在しません。'
      elsif tax_class.destroy
        redirect_index TaxClass.model_name.human + "「#{tax_class.name}」を削除しました。"
      else
        redirect_index '削除に失敗しました。' + fetch_errors(tax_class)
      end
    end

    private

    def redirect_index(message)
      redirect_to admin_tax_classes_url, notice: message
    end

    def tax_class_params
      params.require(:tax_class).permit(:name, :tax_rate)
    end
  end
end
