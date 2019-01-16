module Admin
  class TaxRatesController < ApplicationController
    def index
      @q = TaxRate.ransack(params[:q])
      @q.sorts = 'id desc'
      @tax_rates = @q.result(distinct: true).page(params[:page])
    end

    def show
      @tax_rate = TaxRate.find(params[:id])
    end

    def new
      @tax_rate = TaxRate.new
    end

    def create
      @tax_rate = TaxRate.new(tax_rate_params)

      if @tax_rate.save
        redirect_to admin_tax_rates_path, notice: TaxRate.model_name.human + "「#{@tax_rate.name}」を登録しました。"
      else
        render :new
      end
    end

    def edit
      @tax_rate = TaxRate.find(params[:id])
    end

    def update
      @tax_rate = TaxRate.find(params[:id])
      if @tax_rate.update(tax_rate_params)
        redirect_to admin_tax_rates_path, notice: TaxRate.model_name.human + "「#{@tax_rate.name}」を更新しました。"
      else
        render :edit
      end
    end

    def destroy
      tax_rate = TaxRate.find_by(id: params[:id])
      if tax_rate.nil?
        redirect_index '削除に失敗しました。対象の' + TaxRate.model_name.human + 'は存在しません。'
      elsif tax_rate.destroy
        redirect_index TaxRate.model_name.human + "「#{tax_rate.name}」を削除しました。"
      else
        redirect_index '削除に失敗しました。' + fetch_errors(tax_rate)
      end
    end

    private

    def redirect_index(message)
      redirect_to admin_tax_rates_url, notice: message
    end

    def tax_rate_params
      params.require(:tax_rate).permit(:name, :tax, :start_date,
                                       :standard_tax_rate, :reduced_tax_rate)
    end
  end
end
