module Typus
  module Orm
    module ClassMethods
      module Search

        def build_search_conditions(key, value, conditions)
          query = ActiveRecord::Base.connection.quote_string(value.downcase)
          search = []
          typus_search_fields.each do |key, value|
            _query = case value
                     when "=" then query
                     when "^" then "#{query}%"
                     when "@" then "%#{query}%"
                     end
            table_key = (adapter == 'postgresql') ? "LOWER(TEXT(#{table_name}.#{key}))" : "`#{table_name}`.#{key}"
            search << "#{table_key} LIKE '#{_query}'"
          end

          condition = search.join(" OR ")
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
          if value.is_a?(Hash)
            date_format = Date::DATE_FORMATS[typus_date_format(key)]

            begin
              unless value["from"].blank?
                date_from = Date.strptime(value["from"], date_format)
                merge_conditions(conditions, ["`#{table_name}`.#{key} >= ?", date_from])
              end

              unless value["to"].blank?
                date_to = Date.strptime(value["to"], date_format)
                merge_conditions(conditions, ["`#{table_name}`.#{key} <= ?", date_to])
              end
            rescue
            end
          else
            # TODO: Improve and test filters.
            interval = case value
                       when 'today'         then nil
                       when 'last_few_days' then 3.days.ago.to_date..Date.tomorrow
                       when 'last_7_days'   then 6.days.ago.beginning_of_day..Date.tomorrow
                       when 'last_30_days'  then (Date.today << 1)..Date.tomorrow
                       end
            if interval
              condition = ["`#{table_name}`.#{key} BETWEEN ? AND ?", interval.first, interval.last]
            elsif value == 'today'
              condition = ["`#{table_name}`.#{key} = ?", Date.today]
            end
            merge_conditions(conditions, condition)
          end
        end

        def build_string_conditions(key, value, conditions)
          condition = { key => value }
          merge_conditions(conditions, condition)
        end

        alias :build_integer_conditions :build_string_conditions

        #--
        # Sidebar filters:
        #
        # - Booleans: true, false
        # - Datetime: today, last_few_days, last_7_days, last_30_days
        # - Integer & String: *_id and "selectors" (p.ej. category_id)
        #++
        def build_conditions(params)
          conditions, joins = [], []

          query_params = params.dup
          %w(action controller utf8 sort_order page format).each { |p| query_params.delete(p) }

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
