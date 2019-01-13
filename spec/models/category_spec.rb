require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '追加・更新・削除' do
    let(:category1_name) { 'テストカテゴリー' }
    let(:category1) { FactoryBot.create(:category) }

    describe '追加' do
      it 'カテゴリーが追加できること' do
        expect(category1).to be_valid
        expect(Category.find_by(name: category1_name)).to be_truthy
      end
      it 'カテゴリーが複数追加できること' do
        expect(category1).to be_valid

        category_child_name = 'テストカテゴリー2'
        category_child = FactoryBot.create(:category, parent_id: Category.find_by(name: category1_name).id,
                                                      name: category_child_name,
                                                      display_start_datetime: '2019-01-20 10:00:10',
                                                      display_end_datetime: '2019-01-31 10:00:10')
        expect(category_child).to be_valid
        expect(Category.find_by(name: category_child_name)).to be_truthy
      end
    end

    describe '更新' do
      it 'カテゴリーが更新できること' do
        expect(category1).to be_valid
        update_category1 = Category.find_by(name: category1_name)
        expect(update_category1).to be_truthy
        update_category1_name = '更新カテゴリー'
        update_category1.name = update_category1_name
        update_category1.save
        expect(update_category1).to be_valid
        expect(Category.find_by(name: update_category1_name)).to be_truthy
      end
    end
    describe '削除' do
      it 'カテゴリーが削除できること' do
        expect(category1).to be_valid
        delete_category1 = Category.find_by(name: category1_name)
        expect(delete_category1).to be_truthy
        delete_category1.destroy
        expect(Category.all.size).to eq 0
      end
    end
  end

  describe 'バリデーション' do
    describe '親カテゴリーの確認をおこなう' do
      it '親カテゴリーがnilを許容すること' do
        category = FactoryBot.build(:category, parent_id: nil)
        expect(category).to be_valid
      end
      it '親カテゴリーがnilでなくマスタに存在しなければ無効であること' do
        is_expected.to be_invalid_foreign_key('parent_id').value(1)
      end
      it '親カテゴリーが自身のIDの場合、無効であること' do
        category = FactoryBot.create(:category)
        expect(category).to be_valid

        update_category = Category.find_by(name: 'テストカテゴリー')
        expect(update_category).to be_truthy
        update_category.parent_id = update_category.id
        update_category.valid?
        expect(update_category.errors[:parent_id]).to include(I18n.t('errors.messages.assigned_by_self'))
      end
      it '自身より親のカテゴリーに自身IDが親カテゴリーとして登録されている場合、無効であること' do
        category = FactoryBot.create(:category)
        expect(category).to be_valid

        category2 = FactoryBot.create(:category, parent_id: category.id)
        expect(category2).to be_valid
        category.parent_id = category2.id
        category.valid?
        expect(category.errors[:parent_id]).to include(I18n.t('errors.messages.exists_as_a_parent',
                                                              parent: Category.human_attribute_name(:parent_name)))

        category3 = FactoryBot.create(:category, parent_id: category2.id)
        expect(category3).to be_valid

        category.parent_id = category3.id
        category.valid?
        expect(category.errors[:parent_id]).to include(I18n.t('errors.messages.exists_as_a_parent',
                                                              parent: Category.human_attribute_name(:parent_name)))
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
        category = FactoryBot.build(:category, display_start_datetime: '2019-01-01 00:02:00',
                                               display_end_datetime: '2019-01-01 00:01:00')
        category.valid?
        comparison = Category.human_attribute_name(:display_start_datetime)
        expect(category.errors[:display_end_datetime]).to include(I18n.t('errors.messages.greater_than',
                                                                         count: comparison))
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

  describe '追加・更新・削除　日・時に別れた場合' do
    let(:category1) { FactoryBot.create(:category, is_divide_by_date_and_time: true) }

    describe '追加' do
      it 'カテゴリーが追加できること' do
        expect(category1).to be_valid
        expect(Category.find_by(name: 'テストカテゴリー')).to be_truthy
      end
      it 'カテゴリーが複数追加できること' do
        expect(category1).to be_valid

        category_child = FactoryBot.create(:category, parent_id: Category.find_by(name: 'テストカテゴリー').id,
                                                      name: 'テストカテゴリー2',
                                                      display_start_datetime_ymd: '2019-01-20',
                                                      display_start_datetime_hn: '10:00',
                                                      display_end_datetime_ymd: '2019-01-31',
                                                      display_end_datetime_hn: '12:22',
                                                      is_divide_by_date_and_time: true)
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
        update_category1.is_divide_by_date_and_time = true
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
        expect(Category.all.size).to eq 0
      end
    end
  end

  describe 'バリデーション 日・時に別れた場合' do
    describe '掲載開始日時の確認をおこなう' do
      it '掲載開始日・時がnilを許容すること' do
        category = FactoryBot.build(:category, display_start_datetime_ymd: nil,
                                               display_start_datetime_hn: nil,
                                               is_divide_by_date_and_time: true)
        expect(category).to be_valid
      end
      it '掲載開始日・時がnilでも日・時でもなければ無効であること' do
        category = FactoryBot.build(:category, display_start_datetime_ymd: '2018-01-01',
                                               display_start_datetime_hn: '10:20',
                                               display_end_datetime_ymd: '2018-01-02',
                                               display_end_datetime_hn: '10:20',
                                               is_divide_by_date_and_time: true)
        category.valid?
        expect(category.errors[:display_start_datetime_ymd]).to_not include(I18n.t('errors.messages.not_a_date'))
        category2 = FactoryBot.build(:category, display_start_datetime_ymd: '2018-31-01',
                                                display_start_datetime_hn: '20:11',
                                                display_end_datetime_ymd: '2018-01-02',
                                                display_end_datetime_hn: '10:20',
                                                is_divide_by_date_and_time: true)
        category2.valid?
        expect(category2.errors[:display_start_datetime_ymd]).to include(I18n.t('errors.messages.not_a_date'))
        category3 = FactoryBot.build(:category, display_start_datetime_ymd: '2018-01-01',
                                                display_start_datetime_hn: '30:70',
                                                display_end_datetime_ymd: '2018-01-02',
                                                display_end_datetime_hn: '10:20',
                                                is_divide_by_date_and_time: true)
        category3.valid?
        expect(category3.errors[:display_start_datetime_hn]).to include(I18n.t('errors.messages.not_a_time'))
      end
      it '掲載開始日時が掲載終了日時より大きい場合無効であること' do
        category = FactoryBot.build(:category, display_start_datetime_ymd: '2018-01-03',
                                               display_start_datetime_hn: '20:20',
                                               display_end_datetime_ymd: '2018-01-02',
                                               display_end_datetime_hn: '10:20',
                                               is_divide_by_date_and_time: true)
        category.valid?
        comparison = Category.human_attribute_name(:display_start_datetime)
        expect(category.errors[:display_end_datetime]).to include(I18n.t('errors.messages.greater_than',
                                                                         count: comparison))
      end
    end
    describe '掲載終了日時の確認をおこなう' do
      it '掲載終了日時がnilを許容すること' do
        category = FactoryBot.build(:category, display_end_datetime_ymd: nil,
                                               display_end_datetime_hn: nil,
                                               is_divide_by_date_and_time: true)
        expect(category).to be_valid
      end
      it '掲載終了日時がnilでも日時でなければ無効であること' do
        category = FactoryBot.build(:category, display_start_datetime_ymd: '2018-01-01',
                                               display_start_datetime_hn: '10:20',
                                               display_end_datetime_ymd: '2018-01-02',
                                               display_end_datetime_hn: '10:20',
                                               is_divide_by_date_and_time: true)
        category.valid?
        expect(category.errors[:display_end_datetime_ymd]).to_not include(I18n.t('errors.messages.not_a_date'))
        category2 = FactoryBot.build(:category, display_start_datetime_ymd: '2018-31-01',
                                                display_start_datetime_hn: '20:11',
                                                display_end_datetime_ymd: '2018-31-02',
                                                display_end_datetime_hn: '10:20',
                                                is_divide_by_date_and_time: true)
        category2.valid?
        expect(category2.errors[:display_end_datetime_ymd]).to include(I18n.t('errors.messages.not_a_date'))
        category3 = FactoryBot.build(:category, display_start_datetime_ymd: '2018-01-01',
                                                display_start_datetime_hn: '11:22',
                                                display_end_datetime_ymd: '2018-01-02',
                                                display_end_datetime_hn: '30:20',
                                                is_divide_by_date_and_time: true)
        category3.valid?
        expect(category3.errors[:display_end_datetime_hn]).to include(I18n.t('errors.messages.not_a_time'))
      end
    end
  end
end
