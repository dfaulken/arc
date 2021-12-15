class PointsAllocationsController < ApplicationController
  before_action :set_points_allocation, only: %i[ show edit update destroy ]
  before_action :authenticate_mod!

  # GET /points_allocations or /points_allocations.json
  def index
    @points_allocations = PointsAllocation.all
  end

  # GET /points_allocations/1 or /points_allocations/1.json
  def show
  end

  # GET /points_allocations/new
  def new
    @points_allocation = PointsAllocation.new
  end

  # GET /points_allocations/1/edit
  def edit
  end

  # POST /points_allocations or /points_allocations.json
  def create
    @points_allocation = PointsAllocation.new(points_allocation_params)

    respond_to do |format|
      if @points_allocation.save
        format.html { redirect_to @points_allocation, notice: "Points allocation was successfully created." }
        format.json { render :show, status: :created, location: @points_allocation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @points_allocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /points_allocations/1 or /points_allocations/1.json
  def update
    respond_to do |format|
      if @points_allocation.update(points_allocation_params)
        format.html { redirect_to @points_allocation, notice: "Points allocation was successfully updated." }
        format.json { render :show, status: :ok, location: @points_allocation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @points_allocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /points_allocations/1 or /points_allocations/1.json
  def destroy
    @points_allocation.destroy
    respond_to do |format|
      format.html { redirect_to points_allocations_url, notice: "Points allocation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_points_allocation
      @points_allocation = PointsAllocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def points_allocation_params
      params.require(:points_allocation).permit(:points_system_id, :position, :points)
    end
end
