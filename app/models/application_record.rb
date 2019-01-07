class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  ROW_PER_PAGE = 5
end
