class TaxClass < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小値
  MINIMUM_TAX_RATE = 0
  # 最大値
  MAXIMUM_TAX_RATE = 1
  # 最小桁数
  MINIMUM_NAME = 2
  # 最大桁数
  MAXIMUM_NAME = 40

  before_destroy :before_destroy_can_not_be_deleted

  has_many :tax_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }

  validates :tax_rate, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: MINIMUM_TAX_RATE,
                                       less_than_or_equal_to: MAXIMUM_TAX_RATE }

  private

  def before_destroy_can_not_be_deleted
    return if TaxClass.count > 1

    errors.add(:tax_class, I18n.t('errors.messages.need_to_leave_at_least_one'))
    throw(:abort)
  end
end
