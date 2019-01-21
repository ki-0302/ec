class ApplicationController < ActionController::Base
  def fetch_errors(target_class)
    return if target_class.errors.blank?

    messages = ''
    target_class.errors.full_messages.each do |message|
      messages += ', ' if messages.present?
      messages += message
    end
    messages
  end

end
