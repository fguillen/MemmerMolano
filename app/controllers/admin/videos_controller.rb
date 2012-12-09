class Admin::VideosController < Admin::AdminController
  before_filter :load_performance

  def index
    @videos = @performance.videos.by_position
    render :json => @videos.map(&:to_json)
  end

  def create
    @video = @performance.videos.new(params[:video])

    if @video.save
      render :json => @video.to_json
    else
      render :json => { :errors => @video.errors.full_messages }
    end
  end

  def destroy
    @video = @performance.videos.find(params[:id])
    @video.destroy

    render :json => { :state => "ok" }
  end

  private

  def load_performance
    @performance = Performance.find(params[:performance_id])
  end
end
