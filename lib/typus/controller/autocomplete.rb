module Typus
  module Controller
    module Autocomplete

      def autocomplete
        get_objects
        data = @resource.limit(20)
        render :json => data.map { |i| { "id" => i.id, "name" => i.to_label } }
      end

    end
  end
end
