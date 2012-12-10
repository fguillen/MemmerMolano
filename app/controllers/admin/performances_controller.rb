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
      redirect_to edit_admin_performance_path(@performance), :notice => "Successfully created performance, now you can add the rest of the details."
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
      render :json => { "status" => "ok" }
    else
      render :json => { "errors" => @performance.errors.full_messages }
    end
  end

  def destroy
    @performance = Performance.find(params[:id])
    @performance.destroy
    redirect_to admin_performances_url, :notice => "Successfully destroyed performance."
  end

  def reorder
    params[:ids].each_with_index do |id, index|
      Performance.update_all(["position=?", index], ["id=?", id])
    end
    render :json => { :status => "ok" }
  end
end
