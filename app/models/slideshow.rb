class Slideshow < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 最小桁数
  MINIMUM_NAME = 2
  MINIMUM_PRIORITY = 0
  # 最大桁数
  MAXIMUM_NAME = 40
  MAXIMUM_DESCRIPTION = 1000
  MAXIMUM_URL = 256
  MAXIMUM_PRIORITY = 999

  validates :name, presence: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }
  validates :description, length: { maximum: MAXIMUM_DESCRIPTION }
  validates :url, length: { maximum: MAXIMUM_URL }
  validates :priority, numericality: { greater_than_or_equal_to: MINIMUM_PRIORITY,
                                       less_than_or_equal_to: MAXIMUM_PRIORITY },
                       presence: true
end
