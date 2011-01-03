module Typus
  module Orm
    module ClassMethods
      module Search

        def build_search_conditions(key, value, conditions)
          query = ActiveRecord::Base.connection.quote_string(value.downcase)

          condition = Array.new.tap do |search|
                        typus_search_fields.each do |key, value|
                          _query = case value
                                   when "=" then query
                                   when "^" then "#{query}%"
                                   when "@" then "%#{query}%"
                                   end
                          table_key = (adapter == 'postgresql') ? "LOWER(TEXT(#{table_name}.#{key}))" : "`#{table_name}`.#{key}"
                          search << "#{table_key} LIKE '#{_query}'"
                        end
                      end.join(" OR ")

          merge_conditions(conditions, condition)
        end

        def build_boolean_conditions(key, value, conditions)
          condition = { key => (value == 'true') ? true : false }
          merge_conditions(conditions, condition)
        end

        def build_datetime_conditions(key, value, conditions)
          tomorrow = Time.zone.now.beginning_of_day.tomorrow
          interval = case value
                     when 'today'         then Time.zone.now.beginning_of_day..tomorrow
                     when 'last_few_days' then 3.days.ago.beginning_of_day..tomorrow
                     when 'last_7_days'   then 6.days.ago.beginning_of_day..tomorrow
                     when 'last_30_days'  then Time.zone.now.beginning_of_day.prev_month..tomorrow
                     end
          condition = ["`#{table_name}`.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
          merge_conditions(conditions, condition)
        end

        def build_has_and_belongs_to_many_conditions(key, value, conditions)
          condition = { key => { :id => value } }
          conditions = merge_conditions(conditions, condition)
          joins << key.to_sym
        end

        def build_date_conditions(key, value, conditions)
          field = "`#{table_name}`.#{key}"

          interval = case value
                     when 'today'         then Date.today
                     when 'last_few_days' then 3.days.ago.to_date..Date.tomorrow
                     when 'last_7_days'   then 6.days.ago.to_date..Date.tomorrow
                     when 'last_30_days'  then 30.days.ago.to_date..Date.tomorrow
                     end

          condition = case interval
                      when Array
                        ["#{field} BETWEEN ? AND ?", interval.first, interval.last]
                      else
                        ["#{field} = ?", interval]
                      end

          merge_conditions(conditions, condition)
        end

        def build_string_conditions(key, value, conditions)
          condition = { key => value }
          merge_conditions(conditions, condition)
        end

        alias :build_integer_conditions :build_string_conditions

        def build_conditions(params)
          conditions, joins = [], []

          query_params = params.dup
          %w(action controller utf8 sort_order order_by page format).each { |p| query_params.delete(p) }

          query_params.delete_if { |k, v| v.empty? }.each do |key, value|
            filter_type = model_fields[key.to_sym] || model_relationships[key.to_sym] || key
            conditions = send("build_#{filter_type}_conditions", key, value, conditions)
          end

          [conditions, joins]
        end

      end
    end
  end
end
