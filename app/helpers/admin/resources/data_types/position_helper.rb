module Admin::Resources::DataTypes::PositionHelper

  def table_position_field(attribute, item, connector = " / ")
    html_position = []

    [ [:move_to_top, "Top"],
      [:move_higher,  "Up"],
      [:move_lower,   "Down"],
      [:move_to_bottom, "Bottom"] ].each do |key, value|

      options = { :controller => "/admin/#{item.class.to_resource}", :action => "position", :id => item.id, :go => key }
      should_be_inactive = (item.respond_to?(:first?) && ([:move_higher, :move_to_top].include?(key) && item.first?)) ||
                           (item.respond_to?(:last?) &&  ([:move_lower, :move_to_bottom].include?(key) && item.last?))
      html_position << link_to_unless(should_be_inactive, Typus::I18n.t(value), params.merge(options)) do |name|
        %w(<span class="inactive">#{name}</span>)
      end
    end

    "#{item.position}<br/><br/>#{html_position.compact.join(connector)}".html_safe
  end

end
