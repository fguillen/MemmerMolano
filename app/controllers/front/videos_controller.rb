class Front::VideosController < Front::FrontController
  def show
    @performance = Performance.find(params[:performance_id])
    @video = @performance.videos.find(params[:id])
  end
end
