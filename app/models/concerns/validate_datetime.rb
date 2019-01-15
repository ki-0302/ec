module ValidateDatetime
  extend ActiveSupport::Concern

  # 表示終了日時より表示開始日時が大きいかのバリデーション
  def validate_start_datetime_is_greater_than_end_datetime(start_datetime, end_datetime,
                                                           caption_start_datetime, caption_end_datetime)
    return if start_datetime.nil? || end_datetime.nil?

    return if start_datetime <= end_datetime

    errors.add(caption_end_datetime, I18n.t('errors.messages.greater_than', count: caption_start_datetime))
  end

  # 表示開始日と表示開始時間のバリデーション
  def validate_datetime_ymd_and_hn(datetime_ymd, datetime_hn, caption_datetime_ymd, caption_datetime_hn)
    return if datetime_ymd.blank? && datetime_hn.blank?

    if !Common::Validation.date(datetime_ymd)
      errors.add(caption_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(datetime_hn)
      errors.add(caption_datetime_hn, I18n.t('errors.messages.not_a_time'))
    end
  end
end
