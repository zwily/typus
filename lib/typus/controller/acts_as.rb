module Typus
  module Controller
    module ActsAs

      ##
      # Change item position:
      #
      #   params[:go] = 'move_to_top'
      #
      # Available positions are move_to_top, move_higher, move_lower, move_to_bottom.
      #
      # NOTE: Only works if `acts_as_list` is installed.
      #
      def position
        @item.send(params[:go])
        notice = Typus::I18n.t("%{model} successfully updated.", :model => @resource.model_name.human)
        redirect_to :back, :notice => notice
      end

    end
  end
end
