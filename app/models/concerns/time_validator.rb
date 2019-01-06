class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      nil
    elsif /\A[0-2]?[0-3]:[0-5]?[0-9]\z/.match?(value)
      value
    else
      record.errors[attribute] << I18n.t('errors.messages.not_a_date')
      nil
    end
  rescue StandardError
    record.errors[attribute] << I18n.t('errors.messages.not_a_date') + 'g'
  end
end
