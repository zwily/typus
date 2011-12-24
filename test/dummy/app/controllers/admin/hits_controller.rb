class Admin::HitsController < Admin::ResourcesController

  def index
    @items = Hit.page(params[:page]).per(25)
    add_resource_action("Edit", {:action => 'edit'})
    add_resource_action("Trash", {:action => "destroy"}, {:confirm => "#{Typus::I18n.t("Trash")}?", :method => 'delete'})
  end

end
