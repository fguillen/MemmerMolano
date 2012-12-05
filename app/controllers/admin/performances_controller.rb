class Admin::PerformancesController < Admin::AdminController
  def index
    @performances = Performance.by_position.all
  end

  def new
    @performance = Performance.new
  end

  def create
    @performance = Performance.new(params[:performance])
    if @performance.save
      redirect_to edit_admin_performance_path(@performance), :notice => "Successfully created performance."
    else
      flash.now[:alert] = "Some errors trying to create the Performance."
      render :action => "new"
    end
  end

  def edit
    @performance = Performance.find(params[:id])
  end

  def update
    @performance = Performance.find(params[:id])
    if @performance.update_attributes(params[:performance])
      redirect_to edit_admin_performance_path(@performance), :notice  => "Successfully updated performance."
    else
      flash.now[:alert] = "Some errors trying to update the Performance."
      render :action => "edit"
    end
  end

  def destroy
    @performance = Performance.find(params[:id])
    @performance.destroy
    redirect_to admin_performances_url, :notice => "Successfully destroyed performance."
  end
end
