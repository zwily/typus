module Admin

  module DashboardHelper

    def applications

      apps = ActiveSupport::OrderedHash.new

      Typus.applications.each do |app|

        available = Typus.application(app).map do |resource|
                      resource if @current_user.resources.include?(resource)
                    end.compact

        next if available.empty?

        apps[app] = available.sort_by { |x| x.constantize.model_name.human }

      end

      render "admin/helpers/applications", 
             :applications => apps

    end

    def resources

      available = Typus.resources.map do |resource|
                    resource if @current_user.resources.include?(resource)
                  end.compact

      return if available.empty?

      render "admin/helpers/resources", 
             :resources => available

    end

  end

end
