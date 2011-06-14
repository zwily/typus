module Admin::DashboardHelper

  def resources(admin_user)
    available = Typus.resources.delete_if { |r| !(admin_user.is_a?(FakeUser) || admin_user.resources.include?(r)) }
    render "helpers/admin/dashboard/resources", :resources => available
  end

end
