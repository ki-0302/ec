class TaxItem < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小桁数
  MINIMUM_NAME = 2
  # 最大桁数
  MAXIMUM_NAME = 40

  has_many :products, dependent: :restrict_with_error

#  enum tax: { standard: 0, reduced: 1, fee: 9 }, _prefix: true

  validates :name, presence: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }

  validates :tax_class_id, presence: true
  validates :tax_class_id, numericality: { only_integer: true }

  def tax_class_name
    tax_class.name
  end
end
