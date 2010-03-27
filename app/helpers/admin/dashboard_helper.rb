module Admin::DashboardHelper

  include TypusHelper

  def applications

    apps = ActiveSupport::OrderedHash.new

    Typus.applications.each do |app|

      available = Typus.application(app).map do |resource|
                    resource if @current_user.resources.include?(resource)
                  end.compact

      next if available.empty?

      apps[app] = available.sort_by { |x| x.constantize.typus_human_name }

    end

    render "admin/helpers/applications", :applications => apps

  end

  def resources

    available = Typus.resources.map do |resource|
                  resource if @current_user.resources.include?(resource)
                end.compact

    return if available.empty?

    render "admin/helpers/resources", :resources => available

  end

end
