require "rails_helper"

RSpec.describe AdminUser, type: :model do
  let(:admin_user1) { FactoryBot.create(:admin_user) }
  let(:admin_user2) do
    FactoryBot.create(:admin_user, user_name: "テストユーザー2", email: "test2@example.com",
                                   password: "password2")
  end

  describe "新規登録" do
    it "管理ユーザーが登録できること" do
      expect(admin_user1).to be_valid
      expect(AdminUser.find_by(user_name: "テストユーザー")).to be_truthy
    end
    it "管理ユーザーが複数登録できること" do
      expect(admin_user1).to be_valid
      expect(admin_user2).to be_valid
      expect(AdminUser.all.size).to eq 2
      expect(AdminUser.find_by(user_name: "テストユーザー")).to be_truthy
      expect(AdminUser.find_by(user_name: "テストユーザー2")).to be_truthy
    end
  end

  describe "更新" do
    it "管理ユーザーが更新できること" do
      expect(admin_user1).to be_valid
      update_admin_user1 = AdminUser.find_by(user_name: "テストユーザー")
      expect(update_admin_user1).to be_truthy
      update_admin_user1.user_name = "更新ユーザー"
      update_admin_user1.save
      expect(update_admin_user1).to be_valid
      expect(AdminUser.find_by(user_name: "更新ユーザー")).to be_truthy
    end
  end

  describe "削除" do
    it "管理ユーザーが削除できること" do
      expect(admin_user1).to be_valid
      delete_admin_user1 = AdminUser.find_by(user_name: "テストユーザー")
      expect(delete_admin_user1).to be_truthy
      delete_admin_user1.destroy
      expect(delete_admin_user1).to be_valid
      expect(AdminUser.all.size).to eq 0
    end
  end

  # - [ ] 更新
  #   - [ ] 管理ユーザーが更新できること
  #   - [ ] 管理ユーザーが複数更新できること
  # - [ ] 削除
  #   - [ ] 管理ユーザーが削除できること
  #   - [ ] 管理ユーザーが複数削除できること
  # - [ ] バリデーションをおこなう
  #   - [ ] ユーザー名の確認をおこなう
  #     - [ ] ユーザー名が必須であること
  #     - [ ] ユーザー名が2〜40文字であること
  #   - [ ] メールアドレスの確認をおこなう
  #     - [ ] メールアドレスが必須であること
  #     - [ ] メールアドレスが半角であること
  #     - [ ] メールアドレスが4〜64文字であること
  #     - [ ] 有効なメールアドレスであること
  #     - [ ] 重複したメールアドレスは許可しないこと
  #   - [ ] パスワード項目の確認をおこなう
  #     - [ ] パスワードが必須であること
  #     - [ ] パスワードが半角英数字記号であること
  #     - [ ] パスワードが6〜32文字であること
  #     - [ ] パスワードがハッシュ化されていること

end
