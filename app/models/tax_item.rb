class TaxItem < ApplicationRecord
  enum tax_class: { standard_tax: 1, reduced_tax: 2, no_tax: 9 }

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :tax_class_id, presence: true
  validates :tax_class_id, numericality: { only_integer: true }
  validates :tax_class_id, inclusion: { in: [TaxItem.tax_classes[:standard_tax], TaxItem.tax_classes[:reduced_tax]] }
end
