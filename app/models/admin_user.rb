class AdminUser < ApplicationRecord
  has_secure_password
  before_validation :set_nameless_name

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :email, presence: true
  validates :email, length: { minimum: 5, maximum: 64 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true

  # validates :password, presence: true
  validates :password, length: { minimum: 6, maximum: 32 }, if: :validate_password?
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d!#$%&\(\)@{}]*\z/ }, if: :validate_password?

  def validate_password?
    password.present? || password_confirmation.present?
  end

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end
end
