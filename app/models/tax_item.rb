class TaxItem < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小桁数
  MINIMUM_NAME = 2
  # 最大桁数
  MAXIMUM_NAME = 40

  has_many :products, dependent: :restrict_with_error

  enum tax: { standard: 0, reduced: 1, fee: 9 }, _prefix: true

  validates :name, presence: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }

  validates :tax, presence: true

  def tax_name
    human_attribute_enum(:tax)
  end
end
