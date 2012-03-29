module Admin::Resources::PaginationHelper

  def admin_paginate(items, options)
    if defined?(Kaminari)
      paginate(items, options)
    elsif defined?(WillPaginate)
      will_paginate(items, options)
    else
      render :partial => "admin/resources/pagination"
    end
  end

end
