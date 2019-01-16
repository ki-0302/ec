require 'rails_helper'

RSpec.describe Slideshow, type: :model do
  describe '追加・更新・削除' do
    let(:slideshow_name) { 'テストスライドショー' }
    let(:slideshow) { FactoryBot.create(:slideshow, name: slideshow_name) }

    describe '追加' do
      it 'スライドショーが追加できること' do
        expect(slideshow).to be_valid
        expect(Slideshow.find_by(name: slideshow_name)).to be_truthy
      end
      it 'スライドショーが複数追加できること' do
        expect(slideshow).to be_valid

        slideshow2_name = 'テストスライドショー2'
        slideshow2 = FactoryBot.create(:slideshow, name: slideshow2_name)
        expect(slideshow2).to be_valid
        expect(Slideshow.find_by(name: slideshow2_name)).to be_truthy
      end
    end
    describe '更新' do
      it 'スライドショーが更新できること' do
        expect(slideshow).to be_valid
        update_slideshow = Slideshow.find_by(name: slideshow_name)
        expect(update_slideshow).to be_truthy
        update_slideshow_name = '更新スライドショー'
        update_slideshow.name = update_slideshow_name
        update_slideshow.save
        expect(update_slideshow).to be_valid
        expect(Slideshow.find_by(name: update_slideshow_name)).to be_truthy
      end
    end
    describe '削除' do
      it 'スライドショーが削除できること' do
        expect(slideshow).to be_valid
        delete_slideshow = Slideshow.find_by(name: slideshow_name)
        expect(delete_slideshow).to be_truthy
        delete_slideshow.destroy
        expect(Slideshow.all.size).to eq 0
      end
    end
  end
  describe 'バリデーション' do
    describe '名称の確認をおこなう' do
      it '名称が未入力であれば無効であること' do
        slideshow = FactoryBot.build(:slideshow, name: '')
        slideshow.valid?
        expect(slideshow.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it '名称が最小文字以上でなければ無効であること' do
        slideshow = FactoryBot.build(:slideshow, name: 'A' * (Slideshow::MINIMUM_NAME - 1))
        slideshow.valid?
        expect(slideshow.errors[:name]).to include(I18n.t('errors.messages.too_short', count: Slideshow::MINIMUM_NAME))
      end
      it '名称が最大文字以内でなければ無効であること' do
        slideshow = FactoryBot.build(:slideshow, name: 'A' * (Slideshow::MAXIMUM_NAME + 1))
        slideshow.valid?
        expect(slideshow.errors[:name]).to include(I18n.t('errors.messages.too_long', count: Slideshow::MAXIMUM_NAME))
      end
    end
    describe 'スライドショー詳細の確認をおこなう' do
      it 'スライドショー詳細がnilを許容すること' do
        slideshow = FactoryBot.build(:slideshow, description: nil)
        expect(slideshow).to be_valid
      end
      it 'スライドショー詳細が最大文字以内でなければ無効であること' do
        slideshow = FactoryBot.build(:slideshow, description: 'A' * (Slideshow::MAXIMUM_DESCRIPTION + 1))
        slideshow.valid?
        expect(slideshow.errors[:description]).to include(I18n.t('errors.messages.too_long', count: Slideshow::MAXIMUM_DESCRIPTION))
      end
    end
    describe 'URLの確認をおこなう' do
      it 'URLがnilを許容すること' do
        slideshow = FactoryBot.build(:slideshow, url: nil)
        expect(slideshow).to be_valid
      end
      it 'URLが最大文字以内でなければ無効であること' do
        slideshow = FactoryBot.build(:slideshow, url: 'A' * (Slideshow::MAXIMUM_URL + 1))
        slideshow.valid?
        expect(slideshow.errors[:url]).to include(I18n.t('errors.messages.too_long', count: Slideshow::MAXIMUM_URL))
      end
    end
    describe 'スライドショー画像の確認をおこなう' do
      it 'スライドショー画像が登録できること' do
        slideshow = FactoryBot.build(:slideshow)
        slideshow.image.attach(io: File.open(fixture_path + '/dummy_image.jpg'),
                               filename: 'attachment.jpg', content_type: 'image/jpg')
        expect(slideshow.image).to be_attached
      end
      it 'スライドショー画像が削除できること' do
        slideshow = FactoryBot.build(:slideshow)
        slideshow.image.attach(io: File.open(fixture_path + '/dummy_image.jpg'),
                               filename: 'attachment.jpg', content_type: 'image/jpg')
        slideshow.delete_image = '1'
        slideshow.save
        expect(slideshow.image).to_not be_attached
      end
    end
  end
end
