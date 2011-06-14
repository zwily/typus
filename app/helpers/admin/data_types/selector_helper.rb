module Admin
  module DataTypes
    module SelectorHelper

      def table_selector_field(attribute, item)
        item.mapping(attribute)
      end

      def display_selector(item, attribute)
        item.mapping(attribute)
      end

    end
  end
end
