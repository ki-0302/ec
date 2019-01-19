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

  # json respnse
  def render_json_success(json_data, action_name)
    render status: 200, json: { status: 200, message: "Success", data: json_data + " #{action_name.capitalize}" }
  end

  def render_json_bad_request
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  def render_json_unauthorized
    render status: 401, json: { status: 401, message: 'Unauthorized' }
  end

  def render_json_not_found(class_name = 'page')
    render status: 404, json: { status: 404, message: "#{class_name.capitalize} Not Found" }
  end

  def render_json_conflict(class_name)
    render status: 409, json: { status: 409, message: "#{class_name.capitalize} Conflict" }
  end

  def render_json_internal_server_error
    render status: 500, json: { status: 500, message: 'Internal Server Error' }
  end
end
