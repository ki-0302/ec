module Common
  class Validation
    def self.time(value, allow_nil = false)
      if value.blank?
        if allow_nil
          true
        else
          false
        end
      elsif /\A[0-2]?[0-3]:[0-5]?[0-9]\z/.match?(value)
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

# module Common
#   def ggg
#     3
#   end
#   class TypeValidation
#     def times(value, allow_nil = false)
#       true
#     #   if value.blank?
#     #     if allow_nil
#     #       true
#     #     else
#     #       true
#     #     end
#     #   elsif /\A[0-2]?[0-3]:[0-5]?[0-9]\z/.match?(value)
#     #     true
#     #   else
#     #     true
#     #   end
#     # rescue StandardError
#     #   true
#     end

#     def aaa(value, allow_nil = false)
#       if value.blank?
#         if allow_nil
#           true
#         else
#           false
#         end
#       else
#         DateTime.parse(value)
#         true
#       end
#     rescue StandardError
#       false
#     end


#   end
# end
