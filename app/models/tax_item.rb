class TaxItem < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小桁数
  MINIMUM_NAME = 2
  # 最大桁数
  MAXIMUM_NAME = 40

  belongs_to :tax_class

  validates :name, presence: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }

  validates :tax_class_id, presence: true
  validates :tax_class_id, numericality: { only_integer: true }

  def tax_class_name
    tax_class.name
  end
end
