class TaxClass < ApplicationRecord
  # 初期値で登録されているID
  DEFAULT_TAX_CLASS_ID = 1

  before_destroy :before_destroy_can_not_be_deleted

  has_many :tax_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :tax_rate, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 1 }

  private

  def before_destroy_can_not_be_deleted
    return if id != DEFAULT_TAX_CLASS_ID

    errors.add(:id, I18n.t('errors.messages.can_not_be_deleted',
                           target: DEFAULT_TAX_CLASS_ID))
  end
end
