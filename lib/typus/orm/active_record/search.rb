module Typus
  module Orm
    module ActiveRecord
      module Search

        include Typus::Orm::Base::Search

        def build_search_conditions(key, value)
          data = Array.new.tap do |search|
            query = ::ActiveRecord::Base.connection.quote_string(value.downcase)

            typus_search_fields.each do |local_key, local_value|
              _query = case local_value
                       when '=' then query
                       when '^' then "#{query}%"
                       when '@' then "%#{query}%"
                       end

              column_name = (local_key.match('\.') ? local_key : "#{table_name}.#{local_key}")
              table_key = (adapter == 'postgresql') ? "LOWER(TEXT(#{column_name}))" : "#{column_name}"

              search << "#{table_key} LIKE '#{_query}'"
            end
          end

          data.join(' OR ')
        end

        # TODO: Use Rails scopes to build the search: where(key => interval)
        def build_filter_interval(interval, key)
          ["#{table_name}.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
        end

        def build_my_joins(params)
          query_params = params.dup
          query_params.reject! { |k, _| !model_relationships.keys.include?(k.to_sym) }
          query_params.compact.map { |k, _| k.to_sym }
        end

      end
    end
  end
end
