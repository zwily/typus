module Admin::Resources::SidebarHelper

  def build_sidebar
    locals = { sidebar_title: t('Dashboard'), actions: []}

    if @resource
      locals[:actions] = [sidebar_list(@resource.name), sidebar_add_new(@resource.name)].compact
      locals[:sidebar_title] = @resource.model_name.human(count: 1_000)
    end

    render 'helpers/admin/resources/sidebar', locals
  end

  def sidebar_add_new(klass)
    return if admin_user.cannot?('create', klass)

    {
      message: t('Add'),
      url: { controller: "/admin/#{klass.to_resource}", action: 'new' },
      icon: 'plus',
    }
  end

  def sidebar_list(klass)
    return if admin_user.cannot?('read', klass)

    {
      message: t('List'),
      url: { controller: "/admin/#{klass.to_resource}", action: 'index' },
      icon: 'list',
    }
  end

  # TODO: Move it to the header.
  def sidebar_view_site
    if Typus.link_to_view_site
      {
        message: t('View Site'),
        url: Typus.admin_title_link,
        link_to_options: { target: '_blank' },
        icon: 'share',
      }
    end
  end

end
