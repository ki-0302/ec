class TaxClass < ApplicationRecord
  has_many :tax_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :tax_class_id, presence: true
  validates :tax_class_id, numericality: { greater_than_or_equal_to: 0,
                                           less_than_or_equal_to: 1 }
end
