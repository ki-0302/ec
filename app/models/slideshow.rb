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

  # 画像削除用のID
  attr_accessor :delete_image

  has_one_attached :image

  validates :name, presence: true,
                   length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }
  validates :description, length: { maximum: MAXIMUM_DESCRIPTION }
  validates :url, length: { maximum: MAXIMUM_URL }
  validates :priority, numericality: { greater_than_or_equal_to: MINIMUM_PRIORITY,
                                       less_than_or_equal_to: MAXIMUM_PRIORITY },
                       presence: true

  # 画像を削除
  after_save :image_purge
  validate :image_save

  private

  def image_purge
    image.purge if delete_image == '1'
  end

  def image_save
    image.variant(resize: '100x100') if image.attached?
  end
end
