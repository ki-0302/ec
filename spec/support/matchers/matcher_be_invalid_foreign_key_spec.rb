require 'rspec/expectations'

RSpec::Matchers.define :be_invalid_foreign_key do |expected|
  match do |actual|
    table_name = actual.class.table_name.singularize
    data = FactoryBot.build(table_name)
    data.send("#{expected}=", @value)
    data.save!(validate: false)
    false
  rescue ActiveRecord::InvalidForeignKey
    true
  end

  failure_message_when_negated do
    I18n.t('errors.messages.invalid_foreign_key')
  end

  chain :value do |value|
    @value = value
  end
end
