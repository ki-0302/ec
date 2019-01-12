require 'rails_helper'

RSpec.describe TaxClass, type: :model do
  describe '追加・更新・削除' do
    describe '追加' do
      it '税区分が追加できること' do
      end
      it '税区分が複数追加できること' do
      end
    end
    describe '更新' do
      it '税区分が更新できること' do
      end
    end
    describe '削除' do
      it '税区分が削除できること' do
      end
      it '税区分のIDが1であれば削除は無効であること' do
      end
    end
  end
  describe 'バリデーション' do
    describe '税区分名の確認をおこなう' do
      it '税区分名が未入力であれば無効であること' do
      end
      it '税区分名が2文字以上でなければ無効であること' do
      end
      it '税区分名が40文字以内でなければ無効であること' do
      end
    end
    describe '税率の確認をおこなう' do
      it '税率が未入力であれば無効であること' do
      end
      it '税率が数値でなければ無効であること' do
      end
    end
  end
end
