module Admin
  class AdminUsersController < ApplicationController
    def index
      @admin_users = AdminUser.all
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
      admin_user = AdminUser.find(params[:id])
      admin_user.destroy
      redirect_to admin_admin_users_url, notice: AdminUser.model_name.human + "「#{admin_user.name}」を削除しました。"
    end

    private

    def admin_user_params
      params.require(:admin_user).permit(:name, :email, :admin, :password, :password_confirmation)
    end
  end
end
