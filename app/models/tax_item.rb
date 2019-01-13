class TaxItem < ApplicationRecord
  belongs_to :tax_class

  validates :name, presence: true,
                   length: { minimum: 2, maximum: 40 }

  validates :tax_class_id, presence: true
  validates :tax_class_id, numericality: { only_integer: true }

  def tax_class_name
    tax_class.name
  end
end
