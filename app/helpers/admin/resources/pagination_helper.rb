module Admin::Resources::PaginationHelper

  def admin_paginate(items, options)
    helper = if defined?(Kaminari)
      "paginate"
    elsif defined?(WillPaginate)
      "will_paginate"
    else
      "typus_paginate"
    end

    send(helper, items, options)
  end

  # TODO: Quick and dirty pagination solution! We only want to go back and
  # forward, so it will be simple.
  def typus_paginate(items, options)
    render "admin/resources/pagination"
  end

end
