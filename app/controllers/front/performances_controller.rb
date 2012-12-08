class Front::PerformancesController < Front::FrontController
  def show
    @performance = Performance.find(params[:id])
  end

  def extras
    @performance = Performance.find(params[:id])
  end

  def video
    @performance = Performance.find(params[:id])
  end

  def last
    @performance = Performance.by_position.last
    redirect_to [:front, @performance]
  end
end
