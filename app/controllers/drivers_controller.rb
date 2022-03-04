class DriversController < ApplicationController
  before_action :set_championship, only: %i[ create edit new index numbers update ]
  before_action :set_driver, only: %i[ show edit update destroy ]
  before_action :authenticate_mod!, except: %i[ index show numbers ]

  # GET /drivers or /drivers.json
  def index
    @drivers = @championship.drivers
  end

  # GET /drivers/1 or /drivers/1.json
  def show
    construct_driver_results
    @incidents = @driver.incidents
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
    @entry = ChampionshipDriver.new championship: @championship, driver: @driver
  end

  # GET /drivers/1/edit
  def edit
    @entry = @driver.championship_entry(@championship)
  end

  # POST /drivers or /drivers.json
  def create
    @driver = Driver.new(driver_params)
    @entry = ChampionshipDriver.new(championship_driver_params)
    @entry.driver = @driver

    respond_to do |format|
      if @driver.save && @entry.save
        format.html { redirect_to drivers_path(championship: @championship), notice: "Driver was successfully created and registered to championship." }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1 or /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params) && @driver.championship_entry(@championship).update(championship_driver_params)
        format.html { redirect_to drivers_path(championship: @championship), notice: "Driver was successfully updated." }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1 or /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url(championship: @championship), notice: "Driver was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def numbers
    @drivers = @championship.championship_drivers.with_car_number.sort_by(&:car_number_as_integer).map(&:driver)
    @by_season = @drivers.group_by do |driver|
      driver.last_season_raced(@championship)
    end
    @free = @championship.free_numbers_below_100
    #binding.pry
  end

  private
    def set_championship
      @championship = Championship.find params.require(:championship)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def driver_params
      params.require(:driver).permit(:name, :car_number, championship_driver: %i[car_number championship_id]).except(:championship_driver)
    end

    def championship_driver_params
      params.require(:driver).require(:championship_driver).permit(:car_number, :championship_id)
    end

    def construct_driver_results
      @results = {}
      @driver.championships.includes(seasons: [:standings, races: :results]).each do |championship|
        @results[championship] = {}
        @results[championship][:seasons] = {}
        championship.seasons.select do |season|
          season.drivers.include? @driver          
        end.each do |season|
          races = {}
          season.races.each do |race|
            races[race] = race.results.find_by(driver_id: @driver.id)
          end
          @results[championship][:seasons][season] = {
            standing: season.standings.find_by(driver_id: @driver.id,
              track_type: SeasonStanding.effective_track_type(TrackType.any)),
            races: races
          }
        end
        @results[championship][:table_width] = championship.seasons.max_by do |season|
          season.races.count
        end.races.count
      end
    end
end
