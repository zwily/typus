module Typus

  module Format

    protected

    def generate_html

      items_count = @resource[:class].count(:joins => @joins, :conditions => @conditions)
      items_per_page = @resource[:class].typus_options_for(:per_page).to_i

      @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|

        @resource[:class].find(:all, 
                               :joins => @joins, 
                               :conditions => @conditions, 
                               :order => @order, 
                               :limit => per_page, 
                               :offset => offset)
      end

      @items = @pager.page(params[:page])

      select_template :index

    end

    def generate_csv

      require 'fastercsv'

      @items = @resource[:class].find(:all, :joins => @joins, :conditions => @conditions, :order => @order)

      fields = @resource[:class].typus_fields_for(:csv).collect { |i| i.first }
      csv_string = FasterCSV.generate do |csv|
        csv << fields
        @items.each do |item|
          csv << fields.map { |f| item.send(f) }
        end
      end

      filename = "#{Time.now.strftime("%Y%m%d")}_#{@resource[:self]}.csv"
      send_data(csv_string,
               :type => 'text/csv; charset=utf-8; header=present',
               :filename => filename)

    rescue LoadError
      render :text => "FasterCSV is not installed."
    end

    def generate_xml
      @items = @resource[:class].find(:all, :joins => @joins, :conditions => @conditions, :order => @order)
      render :xml => @items
    end

  end

end