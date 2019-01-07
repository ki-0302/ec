class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    before_type_cast_value = record.send("#{attribute}_before_type_cast").to_s
    if before_type_cast_value.blank?
      nil
    else
      Time.zone.parse(before_type_cast_value)
    end
  rescue StandardError
    record.errors[attribute] << I18n.t('errors.messages.not_a_datetime')
  end
end
