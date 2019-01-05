class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Date.parse(value.to_s)
  rescue StandardError
    record.errors[attribute] << I18n.t('errors.messages.not_a_date')
  end
end
