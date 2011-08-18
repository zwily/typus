module Typus
  module Orm
    module Mongoid
      module ClassMethods

        include Typus::Orm::Base

        def table_name
          collection_name
        end

#        def columns
#          model_fields.keys
#        end

      end
    end
  end
end
