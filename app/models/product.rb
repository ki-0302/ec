class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :tax_item, optional: true

  enum status: { normal: 0, sales_suspension: 9 }

  validates :status_code, inclusion: { in: [Product.status[:normal], Product.status[:sales_suspension]] }

  validates :name, presence: true, length: { minimum: 2, maximum: 40 }
  validates :manufacture_name, length: { minimum: 2, maximum: 40 }
  validates :code, length: { minimum: 2, maximum: 40 }
  validates :sales_price, numericality: { greater_than_or_equal_to: 0,
                                          less_than_or_equal_to: 99_999_999 }
  validates :regular_price, numericality: { greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 99_999_999 }
  validates :number_of_stocks, numericality: { greater_than_or_equal_to: 0,
                                               less_than_or_equal_to: 99_999_999 }
  validates :unlimited_stock, presence: true, inclusion: { in: [true, false] }



  # t.boolean :unlimited_stock, null: false, default: true
  # t.datetime :display_start_datetime
  # t.datetime :display_end_datetime
  # t.string :description
  # t.string :search_term
  # t.string :jan_code
  # t.integer :status_code, null: false, default: 0
end
