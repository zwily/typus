module AdminHelper

  include TypusHelper

  include AdminSidebarHelper
  include AdminFormHelper
  include AdminTableHelper

  def typus_block(name)
    render :partial => "admin/#{@model.name.tableize}/#{name}" rescue nil
  end

  def display_link_to_previous
    returning(String.new) do |html|
      html << <<-HTML
<div id="flash" class="notice">
<p>You're adding a new #{@model.name.downcase} to a model. Do you want to cancel it? <a href="/#{params[:back_to]}">Click Here</a></p>
</div>
      HTML
    end
  end

  ##
  # Simple and clean pagination links
  #
  def windowed_pagination_links(pager, options)
    link_to_current_page = options[:link_to_current_page]
    always_show_anchors = options[:always_show_anchors]
    padding = options[:window_size]
    pg = params[:page].blank? ? 1 : params[:page].to_i
    current_page = pager.page(pg)
    html = ""
    ##
    # Calculate the window start and end pages
    #
    padding = padding < 0 ? 0 : padding
    first = pager.first.number <= (current_page.number - padding) && pager.last.number >= (current_page.number - padding) ? current_page.number - padding : 1
    last = pager.first.number <= (current_page.number + padding) && pager.last.number >= (current_page.number + padding) ? current_page.number + padding : pager.last.number
    ##
    # Print start page if anchors are enabled
    #
    html << yield(1) if always_show_anchors and not first == 1
    ##
    # Print window pages
    #
    first.upto(last) do |page|
      (current_page.number == page && !link_to_current_page) ? html << page.to_s : html << (yield(page)).to_s
    end
    ##
    # Print end page if anchors are enabled
    #
    html << yield(pager.last.number).to_s if always_show_anchors and not last == pager.last.number
    # return the html
    return html
  end

end