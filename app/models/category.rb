class Category < ApplicationRecord
  has_many :category_id, class_name: 'Category', foreign_key: 'parent_id', dependent: :nullify
  belongs_to :parent, class_name: 'Category', optional: true

  validates :parent_id, numericality: true, allow_nil: true

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :display_start_datetime, datetime: true
  validates :display_end_datetime, datetime: true

  validate :validate_start_datetime_is_greater_than_end_datetime

  private

  def validate_start_datetime_is_greater_than_end_datetime
    return if display_start_datetime.nil? || display_end_datetime.nil?

    return if display_start_datetime <= display_end_datetime

    caption_display_start_datetime = Category.human_attribute_name(:display_start_datetime)
    errors.add(:display_end_datetime, I18n.t('errors.messages.greater_than', count: caption_display_start_datetime))
  end
end
