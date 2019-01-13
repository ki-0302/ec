module Admin
  class AdminUsersController < ApplicationController
    def index
      @q = AdminUser.ransack(params[:q])
      @q.sorts = 'id desc'
      @admin_users = @q.result(distinct: true).page(params[:page])
    end

    def show
      @admin_user = AdminUser.find(params[:id])
    end

    def new
      @admin_user = AdminUser.new
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)

      if @admin_user.save
        redirect_to admin_admin_users_path, notice: AdminUser.model_name.human + "「#{@admin_user.name}」を登録しました。"
      else
        render :new
      end
    end

    def edit
      @admin_user = AdminUser.find(params[:id])
    end

    def update
      @admin_user = AdminUser.find(params[:id])
      if @admin_user.update(admin_user_params)
        redirect_to admin_admin_users_url, notice: AdminUser.model_name.human + "「#{@admin_user.name}」を更新しました。"
      else
        render :edit
      end
    end

    def destroy
      admin_user = AdminUser.find_by(id: params[:id])
      if admin_user.nil?
        redirect_index '削除に失敗しました。対象の' + AdminUser.model_name.human + 'は存在しません。'
      elsif admin_user.destroy
        redirect_index AdminUser.model_name.human + "「#{admin_user.name}」を削除しました。"
      else
        redirect_index '削除に失敗しました。' + fetch_errors(admin_user)
      end
    end

    private

    def redirect_index(message)
      redirect_to admin_admin_users_url, notice: message
    end

    def admin_user_params
      params.require(:admin_user).permit(:name, :email, :admin, :password, :password_confirmation)
    end
  end
end
