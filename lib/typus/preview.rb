module Typus

  module InstanceMethods

    def typus_preview(attachment)
      return "<img src=\"#{send(attachment).url(:typus_preview)}\" />"
    end

  end

end

ActiveRecord::Base.send :include, Typus::InstanceMethods