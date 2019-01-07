#require 'type_validation'

class CategoryForm < Category
  attr_accessor :display_start_datetime_ymd, :display_start_datetime_hn
  attr_accessor :display_end_datetime_ymd, :display_end_datetime_hn

  before_validation :set_display_start_datetime
  before_validation :set_display_end_datetime

  validate :validate_display_start_datetime
  validate :validate_display_end_datetime

  private

  def validate_display_start_datetime
    return if display_start_datetime_ymd.blank? && display_start_datetime_hn.blank?

    if !Common::Validation.date(display_start_datetime_ymd)
      errors.add(:display_start_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(display_start_datetime_hn)
      errors.add(:display_start_datetime_hn, I18n.t('errors.messages.not_a_time') + display_start_datetime_hn)
    end
  end

  def validate_display_end_datetime
    return if display_end_datetime_ymd.blank? && display_end_datetime_hn.blank?

    if !Common::Validation.date(display_end_datetime_ymd)
      errors.add(:display_end_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(display_end_datetime_hn)
      errors.add(:display_end_datetime_hn, I18n.t('errors.messages.not_a_time') + display_start_datetime_hn)
    end
  end

  #共通クラスにバリデーションをかく
  #エラーはこのモデルないでadd

  # def initialize(params = nil)
  #   @errors = ActiveModel::Errors.new(self)
  #   if params.present?
  #     category_params = {}
  #     category_params[:parent_id] = params[:parent_id]
  #     category_params[:name] = params[:name]
  #     category_params[:name] = params[:name]
  #     category_params[:name] = params[:name]

  #     @category = Category.new(params)
  #   else
  #     @category = Category.new
  #   end
  # end

  # def save
  #   #@errors.clear
  #   if @category.save
  #     true
  #   else
  #     @category.errors.each do |attribute, error|
  #       @errors.add(Category.human_attribute_name(attribute), error)
  #     end
  #     false
  #   end
  # end

  # validates :display_start_datetime, datetime: true
  # validates :display_end_datetime, datetime: true

  #validate :validate_start_datetime_is_greater_than_end_datetime

  # def display_start_datetime_ymd
  #   @display_start_datetime_ymd ||= display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').first : nil
  # end

  # def display_start_datetime_hn
  #   @display_start_datetime_hn ||= display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').second : nil
  # end

  # def display_end_datetime_ymd
  #   @display_end_datetime_ymd ||= display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').first : nil
  # end

  # def display_end_datetime_hn
  #   @display_end_datetime_hn ||= display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').last : nil
  # end

  # private

  def set_display_start_datetime
    self.display_start_datetime = if display_start_datetime_ymd.blank? || display_start_datetime_hn.blank?
                                    nil
                                  else
                                    begin
                                      Time.zone.parse([@display_start_datetime_ymd, @display_start_datetime_hn].join(' '))
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
                                    Time.zone.parse([@display_end_datetime_ymd, @display_end_datetime_hn].join(' '))
                                  rescue StandardError
                                    nil
                                  end
                                end
  end

  # def validate_start_datetime_is_greater_than_end_datetime
  #   return if display_start_datetime.nil? || display_end_datetime.nil?

  #   caption_display_start_datetime = Category.human_attribute_name(:display_start_datetime)
  #   errors.add(:display_end_datetime, I18n.t('errors.messages.greater_than', count: caption_display_start_datetime)) \
  #   if display_start_datetime > display_end_datetime
  # end

end
