class TaxClass < ApplicationRecord
  before_destroy :before_destroy_can_not_be_deleted

  has_many :tax_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: 2, maximum: 40 }

  validates :tax_rate, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 1 }

  private

  def before_destroy_can_not_be_deleted
    class_name_default = I18n.t('tax_class.name_default')

    return if name != class_name_default

    errors.add(:name, I18n.t('errors.messages.can_not_be_deleted'))
  end
end
