class Admin::PicsController < Admin::AdminController
  before_filter :load_performance

  def index
    @pics = @performance.pics.by_position

    render :json => @pics.map { |e| { :url => e.thumb(:admin) } }
  end

  def create
    @pic = @performance.pics.create!(:thumb => params[:file])
    render :json => { :url => @pic.thumb(:admin) }
  end

  def destroy
    @pic = @performance.pics.find(params[:id])
    @pic.destroy
    redirect_to admin_pics_url, :notice => "Successfully destroyed pic."
  end

  private

  def load_performance
    @performance = Performance.find(params[:performance_id])
  end
end
