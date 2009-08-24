module Typus

  module InstanceMethods

    def typus_preview
      return "<img src=\"#{asset.url(Typus::Configuration.options[:image_preview_size])}\" />"
    end

  end

end

ActiveRecord::Base.send :include, Typus::InstanceMethods