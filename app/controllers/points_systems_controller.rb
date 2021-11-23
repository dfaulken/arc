class PointsSystemsController < ApplicationController
  before_action :set_points_system, only: %i[ show edit update destroy ]

  # GET /points_systems or /points_systems.json
  def index
    @points_systems = PointsSystem.all
  end

  # GET /points_systems/1 or /points_systems/1.json
  def show
  end

  # GET /points_systems/new
  def new
    @points_system = PointsSystem.new
  end

  # GET /points_systems/1/edit
  def edit
  end

  # POST /points_systems or /points_systems.json
  def create
    @points_system = PointsSystem.new(points_system_params)

    respond_to do |format|
      if @points_system.save
        format.html { redirect_to @points_system, notice: "Points system was successfully created." }
        format.json { render :show, status: :created, location: @points_system }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @points_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /points_systems/1 or /points_systems/1.json
  def update
    respond_to do |format|
      if @points_system.update(points_system_params)
        format.html { redirect_to @points_system, notice: "Points system was successfully updated." }
        format.json { render :show, status: :ok, location: @points_system }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @points_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /points_systems/1 or /points_systems/1.json
  def destroy
    @points_system.destroy
    respond_to do |format|
      format.html { redirect_to points_systems_url, notice: "Points system was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_points_system
      @points_system = PointsSystem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def points_system_params
      params.require(:points_system).permit(:name, :worst_rounds_dropped, :pole_position_points, :any_lap_led_points, :most_lap_led_points, :race_finished_points)
    end
end
