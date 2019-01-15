class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # pagination max line
  ROW_PER_PAGE = 10
  ADMIN_ROW_PER_PAGE = 20

  def self.human_attribute_enum_value(attr_name, value)
    human_attribute_name("#{attr_name}.#{value}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, self[attr_name])
  end

  def self.select_from_enum(attr_name)
    send(attr_name.to_s.pluralize).map { |k, _| [human_attribute_enum_value(attr_name, k), k] }.to_h
  end

  def self.human_attribute_boolean_value(attr_name, value)
    value_name = 'false'
    value_name = 'true' if value.is_a?(TrueClass)

    human_attribute_name("#{attr_name}.#{value_name}")
  end

  def human_attribute_boolean(attr_name)
    self.class.human_attribute_boolean_value(attr_name, self[attr_name])
  end

  # def self.human_attribute_boolean(attr_name, value)
  #   human_attribute_name_boolean("#{attr_name}.#{value}")
  # end

  # def human_attribute_name_boolean(attr_name)
  #   self.class.human_attribute_enum_value(attr_name, self[attr_name])
  # end

  # 日付と時間を結合してTimeオブジェクトで取得する
  def combine_display_datetime(date, time)
    if date.blank? || time.blank?
      nil
    else
      begin
        Time.zone.parse([date, time].join(' '))
      rescue StandardError
        nil
      end
    end
  end
end
