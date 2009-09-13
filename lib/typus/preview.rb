module Typus

  module InstanceMethods

    def typus_preview(attachment)
      file_preview = Typus::Configuration.options[:file_preview]
      return "<img src=\"#{send(attachment).url(file_preview)}\" />"
    end

  end

end

ActiveRecord::Base.send :include, Typus::InstanceMethods