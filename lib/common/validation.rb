module Common
  class Validation
    def self.time(value, allow_nil = false)
      if value.blank?
        if allow_nil
          true
        else
          false
        end
      elsif /\A([0-1]?[0-9]|2[0-3]):[0-5]?[0-9](:[0-5]?[0-9])?\z/.match?(value)
        true
      else
        false
      end
    rescue StandardError
      false
    end

    def self.date(value, allow_nil = false)
      if value.blank?
        if allow_nil
          true
        else
          false
        end
      else
        DateTime.parse(value)
        true
      end
    rescue StandardError
      false
    end
  end
end
