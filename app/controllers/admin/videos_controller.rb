class Admin::VideosController < Admin::AdminController
  before_filter :load_performance

  def create
    @video = @performance.videos.new(params[:video])

    if @video.save
      redirect_to edit_admin_performance_path(@performance), :notice => "Successfully created Video."
    else
      redirect_to edit_admin_performance_path(@performance), :alert => "Some errors trying to create the Video."
    end
  end

  def destroy
    @video = @performance.videos.find(params[:id])
    @video.destroy
    redirect_to edit_admin_performance_path(@performance), :notice => "Successfully destroyed Video."
  end

  private

  def load_performance
    @performance = Performance.find(params[:performance_id])
  end
end
