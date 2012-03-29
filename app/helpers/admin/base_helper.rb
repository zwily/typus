module Admin::BaseHelper

  def admin_header
    locals = { :admin_title => admin_title }
    render "helpers/admin/base/header", locals
  end

  def admin_title(page_title = nil)
    if page_title
      content_for(:title) { page_title }
    else
      setting = defined?(Admin::Setting) && Admin::Setting.admin_title
      setting || Typus.admin_title
    end
  end

  def admin_apps
    render "helpers/admin/base/apps"
  end

  def admin_login_info
    render "helpers/admin/base/login_info" unless admin_user.is_a?(FakeUser)
  end

  def admin_sign_out_path
    case Typus.authentication
    when :devise
      send("destroy_#{Typus.user_class_name.underscore}_session_path")
    else
      destroy_admin_session_path
    end
  end

  def admin_edit_user_path(user)
    { :controller => "/admin/#{Typus.user_class.to_resource}", :action => 'edit', :id => user.id }
  end

  def admin_display_flash_message(message = flash)
    if message.keys.any?
      locals = { :flash_type => message.keys.first, :message => message }
      render "helpers/admin/base/flash_message", locals
    end
  end

end
