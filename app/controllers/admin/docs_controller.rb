class Admin::DocsController < AdminController

  def index
    @document = File.read(Typus.root.join("doc", "README.markdown"))
  end

  def show
    @document = File.read(Typus.root.join("doc", "#{params[:id]}.markdown"))
    render :index
  end

end
