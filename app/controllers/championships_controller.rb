class ChampionshipsController < ApplicationController
  before_action :set_championship, only: %i[ deregister_driver show edit register_driver update destroy ]
  before_action :authenticate_mod!, except: %i[ index show ]

  # GET /championships or /championships.json
  def index
    @championships = Championship.all
  end

  # GET /championships/1 or /championships/1.json
  def show
  end

  # GET /championships/new
  def new
    @championship = Championship.new
  end

  # GET /championships/1/edit
  def edit
  end

  # POST /championships or /championships.json
  def create
    @championship = Championship.new(championship_params)

    respond_to do |format|
      if @championship.save
        format.html { redirect_to @championship, notice: "Championship was successfully created." }
        format.json { render :show, status: :created, location: @championship }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @championship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /championships/1 or /championships/1.json
  def update
    respond_to do |format|
      if @championship.update(championship_params)
        format.html { redirect_to @championship, notice: "Championship was successfully updated." }
        format.json { render :show, status: :ok, location: @championship }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @championship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /championships/1 or /championships/1.json
  def destroy
    @championship.destroy
    respond_to do |format|
      format.html { redirect_to championships_url, notice: "Championship was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def deregister_driver
    @driver = Driver.find(params.require(:driver_id))
    @driver.championship_entry(@championship).destroy
    redirect_to drivers_url(championship: @championship), notice: 'Driver was successfully deregistered from championship.'
  end

  def register_driver
    if request.get?
      @drivers = Driver.all - @championship.drivers
    else
      @driver = Driver.find(params.require(:driver_id))
      @entry = ChampionshipDriver.new(championship: @championship, driver: @driver, car_number: params.require(:car_number))
      if @entry.save
        redirect_to drivers_url(championship: @championship), notice: 'Driver registered to championship.'
      else
        redirect_to register_driver_championship_url(@championship), notice: "Car number #{@entry.car_number} is already assigned in this championship."
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_championship
      @championship = Championship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def championship_params
      params.require(:championship).permit(:name, :warnings_convert_to_penalty_points, :number_of_warnings_per_penalty_point)
    end
end
