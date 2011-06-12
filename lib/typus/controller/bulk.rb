module Typus
  module Controller
    module Bulk

      def bulk
        if (ids = params[:selected_item_ids])
          send(params[:batch_action], ids)
        else
          notice = Typus::I18n.t("Items must be selected in order to perform actions on them. No items have been changed.")
          redirect_to :back, :notice => notice
        end
      end

      def bulk_destroy(ids)
        ids.each { |id| @resource.destroy(id) }
        notice = Typus::I18n.t("Successfully deleted #{ids.count} entries.")
        redirect_to :back, :notice => notice
      end
      private :bulk_destroy

      def bulk_restore(ids)
        ids.each { |id| @resource.deleted.find(id).restore }
        notice = Typus::I18n.t("Successfully restored #{ids.count} entries.")
        redirect_to :back, :notice => notice
      end
      private :bulk_restore

    end
  end
end
