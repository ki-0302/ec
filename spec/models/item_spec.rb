require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '新規登録' do
    it '商品が登録できること' do
    end
    it '商品が複数登録できること' do
    end
  end
  describe '更新' do
    it '商品が更新できること' do
    end
  end
  describe '削除' do
    it '商品が削除できること' do
    end
  end
  describe 'バリデーションをおこなう' do
    describe '商品名の確認をおこなう' do
      it '商品名が必須であること' do
      end
      it '商品名が2〜40文字であること' do
      end
    end
    describe '商品コードの確認をおこなう' do
      it '商品コードが必須であること' do
      end
      it '商品コードが半角英数字記号であること' do
      end
      it '商品コードが2〜12文字であること' do
      end
      it '有効な商品コードであること' do
      end
      it '重複した商品コードは許可しないこと' do
      end
    end
    describe 'パスワード項目の確認をおこなう' do
      it 'パスワードが必須であること' do
      end
      it 'パスワードが半角英数字記号であること' do
      end
      it 'パスワードが6〜32文字であること' do
      end
      it 'パスワードがハッシュ化されていること' do
      end
    end
  end
end
