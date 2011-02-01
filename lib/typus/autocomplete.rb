module Typus

  module Autocomplete

    def autocomplete
      if params[:term]
        params.merge!(:search => params[:term])
        get_objects
        @items = @resource.limit(10)
        render :json => @items.map { |i| { "id" => i.id, "label" => i.to_label, "value" => i.to_label } }
      end
    end

  end

end
