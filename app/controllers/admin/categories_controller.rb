module Admin
  class CategoriesController < ApplicationController
    def index
      @categories = Category.page(params[:page]).per(ROW_PER_PAGE)
    end

    def show
      @category = Category.find(params[:id])
    end

    def new
      @category_form = CategoryForm.new
    end

    def create
      @category_form = CategoryForm.new(category_form_params)

      if @category_form.save
        redirect_to admin_categories_path, notice: Category.model_name.human + "「#{@category_form.name}」を登録しました。"
      else
        render :new
      end
    end

    def edit
      @category_form = CategoryForm.find(params[:id])
    end

    def update
      @category_form = CategoryForm.find(params[:id])
      if @category_form.update(category_form_params)
        redirect_to admin_categories_url, notice: Category.model_name.human + "「#{@category_form.name}」を更新しました。"
      else
        render :edit
      end
    end

    def destroy
      category = Category.find(params[:id])
      category.destroy
      redirect_to admin_categories_url, notice: Category.model_name.human + "「#{category.name}」を削除しました。"
    end

    private

    def category_params
      params.require(:category).permit(:name, :parent_id, :display_start_datetime, :display_end_datetime)
    end

    def category_form_params
      params.require(:category_form).permit(:name, :parent_id,
                                            :display_start_datetime_ymd, :display_start_datetime_hn,
                                            :display_end_datetime_ymd, :display_end_datetime_hn)
    end
  end
end
