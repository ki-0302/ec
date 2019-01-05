module Admin
  class CategoriesController < ApplicationController
    def index
      @categories = Category.all
    end

    def show
      @category = Category.find(params[:id])
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: Category.model_name.human + "「#{@category.name}」を登録しました。"
      else
        render :new
      end
    end

    def edit
      @category = Category.find(params[:id])
    end

    def update
      @category = Category.find(params[:id])
      if @category.update(category_params)
        redirect_to admin_categories_url, notice: Category.model_name.human + "「#{@category.name}」を更新しました。"
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
  end
end
