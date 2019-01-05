require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '追加・更新・削除' do
    let(:category1) { FactoryBot.create(:category) }

    describe '追加' do
      it 'カテゴリーが追加できること' do
        expect(category1).to be_valid
        expect(Category.find_by(name: 'テストカテゴリー')).to be_truthy
      end
      it 'カテゴリーが複数追加できること' do
        expect(category1).to be_valid

        category_child = FactoryBot.create(:category, parent_id: Category.find_by(name: 'テストカテゴリー').id, name: 'テストカテゴリー2',
                                                      display_start_datetime: '2019-01-20 10:00:10',
                                                      display_end_datetime: '2019-01-31 10:00:10')
        expect(category_child).to be_valid
        expect(Category.find_by(name: 'テストカテゴリー2')).to be_truthy
      end
    end

    describe '更新' do
      it 'カテゴリーが更新できること' do
        expect(category1).to be_valid
        update_category1 = Category.find_by(name: 'テストカテゴリー')
        expect(update_category1).to be_truthy
        update_category1.name = '更新カテゴリー'
        update_category1.save
        expect(update_category1).to be_valid
        expect(Category.find_by(name: '更新カテゴリー')).to be_truthy
      end
    end
    describe '削除' do
      it 'カテゴリーが削除できること' do
        expect(category1).to be_valid
        delete_category1 = Category.find_by(name: 'テストカテゴリー')
        expect(delete_category1).to be_truthy
        delete_category1.destroy
        expect(delete_category1).to be_valid
        expect(Category.all.size).to eq 0
      end
    end
  end
  describe 'バリデーション' do
    describe '親カテゴリーの確認をおこなう' do
      it '親カテゴリーがnilを許容すること' do
        category = FactoryBot.create(:category, parent_id: nil)
        expect(category).to be_valid
      end
      it '親カテゴリーがnilでなくマスタに存在しなければ無効であること' do
        is_expected.to be_invalid_foreign_key('parent_id').value(1)
      end
    end
    describe 'カテゴリー名の確認をおこなう' do
      it 'カテゴリー名が未入力であれば無効であること' do
        category = FactoryBot.build(:category, name: '')
        category.valid?
        expect(category.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it 'カテゴリー名が2文字以上でなければ無効であること' do
        category = FactoryBot.build(:category, name: 'A')
        category.valid?
        expect(category.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
        category_ja = FactoryBot.build(:category, name: 'Ａ')
        category_ja.valid?
        expect(category_ja.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
      end
      it 'カテゴリー名が40文字以内でなければ無効であること' do
        category = FactoryBot.build(:admin_user, name: 'A' * 41)
        category.valid?
        expect(category.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
        category_ja = FactoryBot.build(:admin_user, name: 'Ａ' * 41)
        category_ja.valid?
        expect(category_ja.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
      end
    end
    describe '掲載開始日時の確認をおこなう' do
      it '掲載開始日時がnilを許容すること' do
        category = FactoryBot.build(:category, display_start_datetime: nil)
        expect(category).to be_valid
      end
      it '掲載開始日時がnilでも日時でもなければ無効であること' do
        category = FactoryBot.build(:category, display_start_datetime: '2018-01-01 10:20',
                                               display_end_datetime: '2018-01-02 10:20')
        category.valid?
        expect(category.errors[:display_start_datetime]).to_not include(I18n.t('errors.messages.not_a_datetime'))
        category2 = FactoryBot.build(:category, display_start_datetime: '2018-01-01 77:33',
                                                display_end_datetime: '2018-01-02 10:20')
        category2.valid?
        expect(category2.errors[:display_start_datetime]).to include(I18n.t('errors.messages.not_a_datetime'))
      end
      it '掲載開始日時が掲載終了日時より大きい場合無効であること' do
        category = FactoryBot.build(:category, display_start_datetime: '2019-01-01 00:02',
                                               display_end_datetime: '2019-01-01 00:01')
        expect(category).to_not be_valid
      end
    end
    describe '掲載終了日時の確認をおこなう' do
      it '掲載終了日時がnilを許容すること' do
        category = FactoryBot.build(:category, display_end_datetime: nil)
        expect(category).to be_valid
      end
      it '掲載終了日時がnilでも日時でなければ無効であること' do
        category = FactoryBot.build(:category, display_start_datetime: '2018-01-01 10:20',
                                               display_end_datetime: '2018-01-02 10:20')
        category.valid?
        expect(category.errors[:display_end_datetime]).to_not include(I18n.t('errors.messages.not_a_datetime'))
        category2 = FactoryBot.build(:category, display_start_datetime: '2018-01-01 10:20',
                                                display_end_datetime: '2018-01-02 77:33')
        category2.valid?
        expect(category2.errors[:display_end_datetime]).to include(I18n.t('errors.messages.not_a_datetime'))
      end
    end
  end
end