class Admin::PicsController < Admin::AdminController
  before_filter :load_performance

  def index
    @pics = @performance.pics.by_position
    render :json => @pics.map(&:to_json)
  end

  def create
    @pic = @performance.pics.create!(:thumb => params[:file])
    render :json => @pic.to_json
  end

  def destroy
    @pic = @performance.pics.find(params[:id])
    @pic.destroy
    render :json => { "status" => "ok" }
  end

  def reorder
    params[:ids].each_with_index do |id, index|
      @performance.pics.update_all(["position=?", index], ["id=?", id])
    end
    render :json => { "status" => "ok" }
  end

  private

  def load_performance
    @performance = Performance.find(params[:performance_id])
  end
end
