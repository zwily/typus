module Admin::Resources::PaginationHelper

  def admin_paginate
    params[:per_page] ||= @resource.typus_options_for(:per_page)
    params[:per_page] = params[:per_page].to_i

    params[:offset] ||= 0
    params[:offset] = params[:offset].to_i

    next_offset = params[:offset] + params[:per_page]
    previous_offset = params[:offset] - params[:per_page]

    options = {}

    if @items.size >= params[:per_page]
      options[:next] = params.merge(offset: next_offset)
    end

    if previous_offset >= 0
      options[:previous] = params.merge(offset: previous_offset)
    end

    render "admin/resources/pagination", { :options => options }
  end

end
