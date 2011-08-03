module Typus
  module Orm
    module Mongo
      module ClassMethods

        include Typus::Orm::Base

        def table_name
          self.collection_name
        end
      end
    end
  end
end
