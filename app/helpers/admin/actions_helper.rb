module Admin
  module ActionsHelper

    def build_actions(&block)
      render "admin/helpers/actions/actions", :block => block
    end

  end
end
