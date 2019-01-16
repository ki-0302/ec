module Admin
  module Contents
    class SlideshowsController < ApplicationController
      def index
        @q = Slideshow.ransack(params[:q])
        @q.sorts = ['priority desc', 'updated_at desc']
        @slideshows = @q.result(distinct: true).page(params[:page])
      end

      def show
        @slideshow = Slideshow.find(params[:id])
      end

      def new
        @slideshow = Slideshow.new
      end

      def create
        @slideshow = Slideshow.new(slideshow_params)

        if @slideshow.save
          redirect_to admin_contents_slideshows_path, notice: Slideshow.model_name.human + "「#{@slideshow.name}」を登録しました。"
        else
          render :new
        end
      end

      def edit
        @slideshow = Slideshow.find(params[:id])
      end

      def update
        @slideshow = Slideshow.find(params[:id])
        if @slideshow.update(slideshow_params)
          redirect_to admin_contents_slideshows_path, notice: Slideshow.model_name.human + "「#{@slideshow.name}」を更新しました。"
        else
          render :edit
        end
      end

      def destroy
        slideshow = Slideshow.find_by(id: params[:id])
        if slideshow.nil?
          redirect_index '削除に失敗しました。対象の' + Slideshow.model_name.human + 'は存在しません。'
        elsif slideshow.destroy
          redirect_index Slideshow.model_name.human + "「#{slideshow.name}」を削除しました。"
        else
          redirect_index '削除に失敗しました。' + fetch_errors(slideshow)
        end
      end

      private

      def redirect_index(message)
        redirect_to admin_contents_slideshows_url, notice: message
      end

      def slideshow_params
        params.require(:slideshow).permit(:name, :description, :url,
                                          :priority, :image, :delete_image)
      end
    end
  end
end
