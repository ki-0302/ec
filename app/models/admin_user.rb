class AdminUser < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小桁数
  MINIMUM_NAME = 2
  MINIMUM_EMAIL = 5
  MINIMUM_PASSWORD = 6
  # 最大桁数
  MAXIMUM_NAME = 40
  MAXIMUM_EMAIL = 64
  MAXIMUM_PASSWORD = 32

  has_secure_password

  before_destroy :before_destroy_can_not_be_deleted

  validates :name, presence: true
  validates :name, length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }

  validates :email, presence: true
  validates :email, length: { minimum: MINIMUM_EMAIL, maximum: MAXIMUM_EMAIL }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true

  validates :password, length: { minimum: MINIMUM_PASSWORD, maximum: MAXIMUM_PASSWORD }, if: :validate_password?
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d!#$%&\(\)@{}]*\z/ }, if: :validate_password?

  private

  def before_destroy_can_not_be_deleted
    return if AdminUser.count > 1

    errors.add(:admin_user, I18n.t('errors.messages.need_to_leave_at_least_one'))
    throw(:abort)
  end

  def validate_password?
    password.present? || password_confirmation.present?
  end
end
