require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe '追加・更新・削除' do
    let(:admin_user1) { FactoryBot.create(:admin_user) }
    let(:admin_user2) do
      FactoryBot.create(:admin_user, name: 'テストユーザー2', email: 'test2@example.com',
                                     password: 'Password2')
    end

    describe '追加' do
      it '管理ユーザーが追加できること' do
        expect(admin_user1).to be_valid
        expect(AdminUser.find_by(name: 'テストユーザー')).to be_truthy
      end
      it '管理ユーザーが複数追加できること' do
        expect(admin_user1).to be_valid
        expect(admin_user2).to be_valid
        expect(AdminUser.all.size).to eq 2
        expect(AdminUser.find_by(name: 'テストユーザー')).to be_truthy
        expect(AdminUser.find_by(name: 'テストユーザー2')).to be_truthy
      end
    end

    describe '更新' do
      it '管理ユーザーが更新できること' do
        expect(admin_user1).to be_valid
        update_admin_user1 = AdminUser.find_by(name: 'テストユーザー')
        expect(update_admin_user1).to be_truthy
        update_admin_user1.name = '更新ユーザー'
        update_admin_user1.save
        expect(update_admin_user1).to be_valid
        expect(AdminUser.find_by(name: '更新ユーザー')).to be_truthy
      end
    end

    describe '削除' do
      it '管理ユーザーが削除できること' do
        expect(admin_user1).to be_valid
        delete_admin_user1 = AdminUser.find_by(name: 'テストユーザー')
        expect(delete_admin_user1).to be_truthy
        delete_admin_user1.destroy
        expect(delete_admin_user1).to be_valid
        expect(AdminUser.all.size).to eq 0
      end
    end
  end

  describe 'バリデーション' do
    let(:admin_user) { FactoryBot.build(:admin_user) }

    describe 'ユーザー名の確認をおこなう' do
      it 'ユーザー名が未入力であれば無効であること' do
        admin_user = FactoryBot.build(:admin_user, name: '')
        admin_user.valid?
        expect(admin_user.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end
      it 'ユーザー名が2文字以上でなければ無効であること' do
        admin_user = FactoryBot.build(:admin_user, name: 'A')
        admin_user.valid?
        expect(admin_user.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
        admin_user_ja = FactoryBot.build(:admin_user, name: 'Ａ')
        admin_user_ja.valid?
        expect(admin_user_ja.errors[:name]).to include(I18n.t('errors.messages.too_short', count: 2))
      end
      it 'ユーザー名が40文字以内でなければ無効であること' do
        admin_user = FactoryBot.build(:admin_user, name: 'A' * 41)
        admin_user.valid?
        expect(admin_user.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
        admin_user_ja = FactoryBot.build(:admin_user, name: 'Ａ' * 41)
        admin_user_ja.valid?
        expect(admin_user_ja.errors[:name]).to include(I18n.t('errors.messages.too_long', count: 40))
      end
    end

    describe 'メールアドレスの確認をおこなう' do
      it 'メールアドレスが未入力であれば無効であること' do
        admin_user = FactoryBot.build(:admin_user, email: '')
        admin_user.valid?
        expect(admin_user.errors[:email]).to include(I18n.t('errors.messages.blank'))
      end
      it 'メールアドレスが64文字以内でなければ無効であること' do
        admin_user = FactoryBot.build(:admin_user, email: '1' * 53 + '@example.com')
        admin_user.valid?
        expect(admin_user.errors[:email]).to include(I18n.t('errors.messages.too_long', count: 64))
      end
      it '有効なメールアドレスでなければ無効であること' do
        admin_user = FactoryBot.build(:admin_user, email: 'testexample.com')
        admin_user.valid?
        expect(admin_user.errors[:email]).to include(I18n.t('errors.messages.invalid'))
      end
      it 'メールアドレスが重複していれば無効であること' do
        admin_user = FactoryBot.create(:admin_user, email: 'test@example.com')
        expect(admin_user).to be_valid
        duplicate_mail = FactoryBot.build(:admin_user, email: 'test@example.com')
        duplicate_mail.valid?
        expect(duplicate_mail.errors[:email]).to include(I18n.t('errors.messages.taken'))
      end
    end

    describe 'パスワード項目の確認をおこなう' do
      it 'パスワードが未入力であれば無効であること' do
        admin_user = FactoryBot.build(:admin_user, password: '')
        admin_user.valid?
        expect(admin_user.errors[:password]).to include(I18n.t('errors.messages.blank'))
      end
      it 'パスワードが半角英数字と特定の記号でなければ無効あること' do
        admin_user = FactoryBot.build(:admin_user, password: '123456Aa!#$%&()@{}')
        admin_user.valid?
        expect(admin_user.errors[:password]).to_not include(I18n.t('errors.messages.invalid'))
        admin_user = FactoryBot.build(:admin_user, password: '123456Aaあ')
        admin_user.valid?
        expect(admin_user.errors[:password]).to include(I18n.t('errors.messages.invalid'))

        check_str = %w['"' ''' '=' '~' '^' '-' ':' ';' '\[' '\]' '{' '}' '_' '?'' '*' '+' '>' '<' '\' ' ' '“' '`']
        check_str.each do |s|
          admin_user = FactoryBot.build(:admin_user, password: '123456Aa' + s)
          admin_user.valid?
          expect(admin_user.errors[:password]).to include(I18n.t('errors.messages.invalid'))
        end
      end
      it 'パスワードが6文字以上でなければ無効であること' do
        admin_user = FactoryBot.build(:admin_user, password: 'Aa123')
        admin_user.valid?
        expect(admin_user.errors[:password]).to include(I18n.t('errors.messages.too_short', count: 6))
      end
      it 'パスワードが32文字以内でなければ無効であること' do
        admin_user = FactoryBot.build(:admin_user, password: 'Aa1' + '2' * 30)
        admin_user.valid?
        expect(admin_user.errors[:password]).to include(I18n.t('errors.messages.too_long', count: 32))
      end
      it '保存されるパスワードがハッシュ化されていなければ無効であること' do
        password = 'Password1'
        admin_user = FactoryBot.create(:admin_user, password: password)
        expect(admin_user).to be_valid
        expect(AdminUser.find_by(name: 'テストユーザー').password_digest).to_not eq password
      end
    end
  end
end
