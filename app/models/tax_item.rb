class TaxItem < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :tax_class_id, presence: true
  validates :tax_class_id, numericality: { only_integer: true }
end
