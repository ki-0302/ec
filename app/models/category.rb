class Category < ApplicationRecord
  has_many :category_id, class_name: 'Category', foreign_key: 'parent_id', dependent: :nullify
  belongs_to :parent, class_name: 'Category', optional: true

  attr_writer :display_start_datetime_ymd, :display_start_datetime_hn,
              :display_end_datetime_ymd, :display_end_datetime_hn

  before_validation :set_display_start_datetime
  before_validation :set_display_end_datetime

  validates :parent_id, numericality: true, allow_nil: true

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :display_start_datetime, datetime: true
  validates :display_end_datetime, datetime: true

  #validate :validate_start_datetime_is_greater_than_end_datetime

  def display_start_datetime_ymd
    @display_start_datetime_ymd ||= display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').first : nil
  end

  def display_start_datetime_hn
    @display_start_datetime_hn ||= display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').second : nil
  end

  def display_end_datetime_ymd
    @display_end_datetime_ymd ||= display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').first : nil
  end

  def display_end_datetime_hn
    @display_end_datetime_hn ||= display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').last : nil
  end

  private

  def set_display_start_datetime
    self.display_start_datetime = if display_start_datetime_ymd.blank? || display_start_datetime_hn.blank?
                                    nil
                                  else
                                    begin
                                      DateTime.parse([@display_start_datetime_ymd, @display_start_datetime_hn].join(' '))
                                    rescue StandardError
                                      nil
                                    end
                                  end
  end

  def set_display_end_datetime
    self.display_end_datetime = if display_end_datetime_ymd.blank? || display_end_datetime_hn.blank?
                                  nil
                                else
                                  begin
                                    DateTime.parse([@display_end_datetime_ymd, @display_end_datetime_hn].join(' '))
                                  rescue StandardError
                                    nil
                                  end
                                end
  end

  def validate_start_datetime_is_greater_than_end_datetime
    return if display_start_datetime.nil? || display_end_datetime.nil?

    caption_display_start_datetime = Category.human_attribute_name(:display_start_datetime)
    errors.add(:display_end_datetime, I18n.t('errors.messages.greater_than', count: caption_display_start_datetime)) \
    if display_start_datetime > display_end_datetime
  end

end
