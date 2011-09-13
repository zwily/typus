module Typus
  module Controller
    module Autocomplete

      def autocomplete
        if params[:term]
          params.merge!(:search => params[:term])
          get_objects
          data = @resource.limit(20)
          render :json => data.map { |i| { "id" => i.id, "value" => i.to_label } }
        end
      end

    end
  end
end
