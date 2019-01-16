class TaxRate < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小桁数
  MINIMUM_NAME = 2
  MINIMUM_TAX_RATE = 0
  # 最大桁数
  MAXIMUM_NAME = 40
  MAXIMUM_TAX_RATE = 1

  validates :name, presence: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }
  validates :start_date, uniqueness: true, presence: true, date: true
  validates :standard_tax_rate, numericality: { greater_than_or_equal_to: MINIMUM_TAX_RATE,
                                                less_than_or_equal_to: MAXIMUM_TAX_RATE },
                                presence: true
  validates :reduced_tax_rate, numericality: { greater_than_or_equal_to: MINIMUM_TAX_RATE,
                                               less_than_or_equal_to: MAXIMUM_TAX_RATE },
                               allow_nil: true
end
