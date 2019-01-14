class TaxClass < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  before_destroy :before_destroy_can_not_be_deleted

  has_many :tax_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: 2, maximum: 40 }

  validates :tax_rate, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 1 }

  private

  def before_destroy_can_not_be_deleted
    return if TaxClass.count > 1

    errors.add(:tax_class, I18n.t('errors.messages.need_to_leave_at_least_one'))
    throw(:abort)
  end
end
