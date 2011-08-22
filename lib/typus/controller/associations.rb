module Typus
  module Controller
    module Associations

      ##
      # Action to relate models which respond to:
      #
      #   - has_and_belongs_to_many
      #   - has_many
      #
      # For example:
      #
      #   class Item < ActiveRecord::Base
      #     has_many :line_items
      #   end
      #
      #   class LineItem < ActiveRecord::Base
      #     belongs_to :item
      #   end
      #
      #   >> related_item = LineItem.find(params[:related][:id])
      #   => ...
      #   >> item = Item.find(params[:id])
      #   => ...
      #   >> item.line_items << related_item
      #   => ...
      #
      def relate
        resource_class = params[:resource].constantize
        association_name = resource_class.table_name

        item = resource_class.find(params[:resource_id])
        @item.send(association_name) << item

        notice = Typus::I18n.t("%{model} successfully updated.", :model => @resource.model_name.human)

        redirect_to params[:return_to], :notice => notice
      end

      ##
      # Action to unrelate models which respond to:
      #
      #   - has_and_belongs_to_many
      #   - has_many
      #   - has_one
      #
      def unrelate
        item_class = params[:resource].constantize
        item = item_class.find(params[:resource_id])

        case item_class.relationship_with(@resource)
        when :has_one
          association_name = @resource.model_name.underscore.to_sym
          worked = item.send(association_name).delete
        else
          association_name = params[:association_name] ? params[:association_name].to_sym : @resource.model_name.tableize.split("/").last.to_sym
          worked = item.send(association_name).delete(@item)
        end

        if worked
          notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)
        else
          alert = item.errors.full_messages
        end

        redirect_to :back, :notice => notice, :alert => alert
      end

      protected

      ##
      #     >> Order.relationship_with(Invoice)
      #     => :has_one
      #
      def set_has_one_association(item_class, options)
        association_name = item_class.model_name.underscore.to_sym
        options.merge!(:action => 'edit', :id => @item.send(association_name).id)
        notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)

        [options, notice, nil]
      end

      ##
      #     >> Entry.relationship_with(Comment)
      #     => :has_many
      #
      def set_has_many_association(item_class, options)
        item = item_class.find(params[:resource_id])
        association_name = @resource.model_name.tableize.to_sym

        if item.send(association_name).push(@item)
          notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)
        else
          alert = @item.errors.full_messages
        end

        options.merge!(:action => 'edit', :id => item.id)

        [options, notice, alert]
      end

    end
  end
end
