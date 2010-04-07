require 'bluecloth'

class Admin::DocsController < AdminController

  def index
    @document = File.read("#{Typus.root}/doc/README.markdown")
  end

  def show
    @document = File.read("#{Typus.root}/doc/#{params[:id]}.markdown")
    render :index
  end

end
