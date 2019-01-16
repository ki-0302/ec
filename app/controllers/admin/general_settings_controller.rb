module Admin
  class GeneralSettingsController < ApplicationController
    def edit
      @general_setting = GeneralSetting.find_by(site_name: 'デモサイト')
      @general_setting.nil? && redirect_index('対象の' + GeneralSetting.model_name.human + 'は存在しません。')
    end

    def update
      @general_setting = GeneralSetting.find(params[:id])
      @general_setting.update(general_setting_params) && flash.now[:notice] = GeneralSetting.model_name.human + 'を更新しました。'
      render :edit
    end

    private

    def redirect_index(message)
      redirect_to admin_products_path, notice: message
    end

    def general_setting_params
      params.require(:general_setting).permit(:site_name, :postal_code, :region,
                                              :address1, :address2, :address3,
                                              :phone_number).merge(is_divide_by_postal_code: true)
    end
  end
end
