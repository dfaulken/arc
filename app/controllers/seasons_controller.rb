class SeasonsController < ApplicationController
  before_action :set_championship, only: %i[index new]
  before_action :set_season, only: %i[ edit update destroy projection recalculate_all ]
  before_action :authenticate_mod!, except: %i[ index projection ]

  # GET /seasons or /seasons.json
  def index
    @seasons = @championship.seasons
    construct_championship_statistics
    @incident_drivers = @championship.drivers_with_active_published_incident_outcomes
  end

  # GET /seasons/new
  def new
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
    @championship = @season.championship
  end

  # POST /seasons or /seasons.json
  def create
    @season = Season.new(season_params)
    @championship = @season.championship

    respond_to do |format|
      if @season.save
        format.html { redirect_to races_path(season: @season), notice: "Season was successfully created." }
        format.json { render :show, status: :created, location: @season }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1 or /seasons/1.json
  def update
    respond_to do |format|
      recalculate_needed = @season.points_system_id_changed?
      if @season.update(season_params)
        @season.calculate_scores!
        @season.races.each(&:award_most_laps_led!)
        @season.calculate_standings!
        format.html { redirect_to races_path(season: @season), notice: "Season was successfully updated." }
        format.json { render :show, status: :ok, location: @season }
      else
        @championship = @season.championship
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1 or /seasons/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to seasons_url, notice: "Season was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def projection
    respond_to do |format|
      format.html do
        if params[:drivers].present?
          @drivers = Driver.find(params.require(:drivers))
          @standings = @season.standings.where track_type: nil
        else
          if params[:selected]
            @selected = Driver.find(params.require(:selected))
          else
            @selected = Driver.none
          end
          @all_drivers = Driver.all
        end
        render :projection
      end
      format.json do
        race = @season.races.select(&:incomplete?).sort_by(&:date).first
        head :bad_request unless race
        render json: @season.calculate_projection(construct_provisional_results(race))
      end
    end
  end

  def recalculate_all
    @season.calculate_scores!
    @season.races.each(&:award_most_laps_led!)
    @season.calculate_standings!
    redirect_to races_path(season: @season, track_type: params[:track_type])
  end

  private

    def construct_championship_statistics
      @statistics = {}
      if @championship.combined?
        @statistics['combined'] = construct_discipline_statistics(TrackType.any)
      end
      @championship.track_types.each do |track_type|
        @statistics[track_type] = construct_discipline_statistics(track_type)
      end
    end

    def construct_discipline_statistics(discipline)
      {
        count: @championship.races_completed(track_type: discipline),
        lap_count: @championship.laps_completed(track_type: discipline),
        wins: @championship.wins(track_type: discipline)
          .group_by(&:driver)
          .map{ |driver, wins| [driver, wins.count]}
          .sort_by(&:last)
          .reverse,
        pole_positions: @championship.pole_positions(track_type: discipline)
          .group_by(&:driver)
          .map{ |driver, poles| [driver, poles.count]}
          .sort_by(&:last)
          .reverse,
        most_laps_led: @championship.results_with_most_laps_led(track_type: discipline)
          .group_by(&:driver)
          .map{ |driver, mll| [driver, mll.count] }
          .sort_by(&:last)
          .reverse,
        laps_led: @championship.results_with_any_laps_led(track_type: discipline)
          .group_by(&:driver)
          .map{ |driver, results| [driver, results.sum(&:laps_led)] }
          .sort_by(&:last)
          .reverse
          .first(10),
        average_finishing_position: @championship.finishes(track_type: discipline)
          .group_by(&:driver)
          .select{|driver, finishes| finishes.count >= 5 }
          .map{|driver, finishes| [driver, finishes.sum(&:position) / finishes.count.to_f]}
          .sort_by(&:last)
          .first(10)
      }
    end

    def construct_provisional_results(race)
      results = []
      # can't require since might be empty
      pole_position_driver = Driver.find_by id: params[:polePosition]
      most_laps_led_driver = Driver.find_by id: params[:ledMostLaps]
      params.require(:drivers).each do |_index, driver_data|
        result = RaceResult.new
        result.race = race
        result.driver = Driver.find_by id: driver_data.require(:driverID)
        result.scored_pole_position = result.driver == pole_position_driver
        result.most_laps_led = result.driver == most_laps_led_driver
        result.laps_led = driver_data.require(:ledLap) == 'true' ? 1 : 0
        result.finished_race = driver_data.require(:dnf) == 'false'
        result.position = driver_data.require(:position).to_i
        results << result
      end
      results
    end

    def set_championship
      @championship = Championship.find params.require(:championship)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def season_params
      params.require(:season).permit(:championship_id, :points_system_id, :index, :name)
    end
end
