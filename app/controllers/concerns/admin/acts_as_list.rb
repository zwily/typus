# Module designed to work with `acts_as_list`.

require 'active_support/concern'

module Admin
  module ActsAsList

    extend ActiveSupport::Concern

    included do
      # before_filter :set_predefined_filter_for_position, only: [:index]
    end

    def set_predefined_filter_for_position
      if admin_user.can?('edit', @resource.model_name)
        add_resource_action('Position', {action: 'position'}, {glyphicon: 'th-list'})
      end
    end
    private :set_predefined_filter_for_position

    def position
      get_object
      check_resource_ownership

      if %w(move_to_top move_higher move_lower move_to_bottom).include?(params[:go])
        @item.send(params[:go])
        notice = Typus::I18n.t("%{model} successfully updated.", model: @resource.model_name.human)
        redirect_to :back, notice: notice
      else
        not_allowed
      end
    end

  end
end
