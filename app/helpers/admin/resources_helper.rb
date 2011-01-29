module Admin

  module ResourcesHelper

    include Admin::ListHelper
    include Admin::FiltersHelper
    include Admin::FormHelper
    include Admin::RelationshipsHelper
    include Admin::FilePreviewHelper
    include Admin::SearchHelper
    include Admin::SidebarHelper
    include Admin::TableHelper

    def display_link_to_previous
      render File.join(path, "display_link_to_previous") if params[:back_to]
    end

    private

    def path
      "admin/helpers/resources"
    end

  end

end
