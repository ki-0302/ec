class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # pagination max line
  ROW_PER_PAGE = 5

  def self.human_attribute_enum(attr_name, value)
    human_attribute_name("#{attr_name}.#{value}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, self[attr_name])
  end
end
