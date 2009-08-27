module Typus

  module InstanceMethods

    def typus_preview
      return "<img src=\"#{asset.url(:typus_preview)}\" />"
    end

  end

end

ActiveRecord::Base.send :include, Typus::InstanceMethods