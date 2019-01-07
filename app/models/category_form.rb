class CategoryForm < Category
  attr_accessor :display_start_datetime_ymd
  attr_accessor :display_start_datetime_hn
  attr_accessor :display_end_datetime_ymd, :display_end_datetime_hn

  before_validation :set_display_start_datetime
  before_validation :set_display_end_datetime

  validate :validate_display_start_datetime
  validate :validate_display_end_datetime

  after_find :set_display_start_datetime_ymd_and_hn
  after_find :set_display_end_datetime_ymd_and_hn

  private

  def set_display_start_datetime_ymd_and_hn
    @display_start_datetime_ymd = display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').first : nil
    @display_start_datetime_hn = display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').second : nil
  end

  def set_display_end_datetime_ymd_and_hn
    @display_end_datetime_ymd = display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').first : nil
    @display_end_datetime_hn = display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').second : nil
  end

  def validate_display_start_datetime
    return if display_start_datetime_ymd.blank? && display_start_datetime_hn.blank?

    if !Common::Validation.date(display_start_datetime_ymd)
      errors.add(:display_start_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(display_start_datetime_hn)
      errors.add(:display_start_datetime_hn, I18n.t('errors.messages.not_a_time'))
    end
  end

  def validate_display_end_datetime
    return if display_end_datetime_ymd.blank? && display_end_datetime_hn.blank?

    if !Common::Validation.date(display_end_datetime_ymd)
      errors.add(:display_end_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(display_end_datetime_hn)
      errors.add(:display_end_datetime_hn, I18n.t('errors.messages.not_a_time'))
    end
  end

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

end
