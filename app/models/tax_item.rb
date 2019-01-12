class TaxItem < ApplicationRecord
  belongs_to :tax_class

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :tax_class, presence: true
  validates :tax_class, numericality: { only_integer: true }
end
