require 'rails_helper'

RSpec.describe CategoryForm, type: :model do
  describe '追加・更新・削除' do
    let(:category_form1) { FactoryBot.create(:category_form) }

    describe '追加' do
      it 'カテゴリーが追加できること' do
        expect(category_form1).to be_valid
        expect(CategoryForm.find_by(name: 'テストカテゴリー')).to be_truthy
      end
      it 'カテゴリーが複数追加できること' do
        expect(category_form1).to be_valid

        category_form_child = FactoryBot.create(:category_form, parent_id: CategoryForm.find_by(name: 'テストカテゴリー').id,
                                                                name: 'テストカテゴリー2',
                                                                display_start_datetime_ymd: '2019-01-20',
                                                                display_start_datetime_hn: '10:00',
                                                                display_end_datetime_ymd: '2019-01-31',
                                                                display_end_datetime_hn: '12:22')
        expect(category_form_child).to be_valid
        expect(CategoryForm.find_by(name: 'テストカテゴリー2')).to be_truthy
      end
    end

    describe '更新' do
      it 'カテゴリーが更新できること' do
        expect(category_form1).to be_valid
        update_category_form1 = CategoryForm.find_by(name: 'テストカテゴリー')
        expect(update_category_form1).to be_truthy
        update_category_form1.name = '更新カテゴリー'
        update_category_form1.save
        expect(update_category_form1).to be_valid
        expect(CategoryForm.find_by(name: '更新カテゴリー')).to be_truthy
      end
    end
    describe '削除' do
      it 'カテゴリーが削除できること' do
        expect(category_form1).to be_valid
        delete_category_form1 = CategoryForm.find_by(name: 'テストカテゴリー')
        expect(delete_category_form1).to be_truthy
        delete_category_form1.destroy
        expect(CategoryForm.all.size).to eq 0
      end
    end
  end
end
