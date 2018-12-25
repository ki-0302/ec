class AdminUser < ApplicationRecord
  has_secure_password

  validates :user_name, presence: true
  validates :user_name, length: { minimum: 2, maximum: 40 }

  validates :email, presence: true
  validates :email, length: { minimum: 5, maximum: 64 }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true
end
