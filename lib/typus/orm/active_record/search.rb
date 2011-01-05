module Typus
  module Orm
    module ClassMethods
      module Search

        def build_search_conditions(key, value)
          Array.new.tap do |search|
            query = ActiveRecord::Base.connection.quote_string(value.downcase)
            typus_search_fields.each do |key, value|
              _query = case value
                       when "=" then query
                       when "^" then "#{query}%"
                       when "@" then "%#{query}%"
                       end
              table_key = (adapter == 'postgresql') ? "LOWER(TEXT(#{table_name}.#{key}))" : "#{table_name}.#{key}"
              search << "#{table_key} LIKE '#{_query}'"
            end
          end.join(" OR ")
        end

        def build_boolean_conditions(key, value)
          { key => (value == 'true') ? true : false }
        end

        def build_datetime_conditions(key, value)
          tomorrow = Time.zone.now.beginning_of_day.tomorrow

          interval = case value
                     when 'today'         then 0.days.ago.beginning_of_day..tomorrow
                     when 'last_few_days' then 3.days.ago.beginning_of_day..tomorrow
                     when 'last_7_days'   then 6.days.ago.beginning_of_day..tomorrow
                     when 'last_30_days'  then 30.days.ago.beginning_of_day..tomorrow
                     end

          ["#{table_name}.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
        end

        def build_date_conditions(key, value)
          tomorrow = 0.days.ago.tomorrow.to_date

          interval = case value
                     when 'today'         then 0.days.ago.to_date..tomorrow
                     when 'last_few_days' then 3.days.ago.to_date..tomorrow
                     when 'last_7_days'   then 6.days.ago.to_date..tomorrow
                     when 'last_30_days'  then 30.days.ago.to_date..tomorrow
                     end

          ["#{table_name}.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
        end

        def build_string_conditions(key, value)
          { key => value }
        end

        alias :build_integer_conditions :build_string_conditions

        def build_conditions(params)
          Array.new.tap do |conditions|
            query_params = params.dup
            %w(action controller utf8 sort_order order_by page format).each { |p| query_params.delete(p) }

            query_params.delete_if { |k, v| v.empty? }.each do |key, value|
              filter_type = model_fields[key.to_sym] || model_relationships[key.to_sym] || key
              conditions << send("build_#{filter_type}_conditions", key, value)
            end
          end
        end

      end
    end
  end
end
