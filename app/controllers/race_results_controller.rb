class RaceResultsController < ApplicationController
  before_action :set_race_result, only: %i[ show edit update  ]
  before_action :set_race, only: %i[index edit record delete_all ]
  before_action :authenticate_mod!, except: %i[ index show ]

  def delete_all
    @race.results.delete_all
    redirect_to race_results_path(race: @race), notice: 'Race results deleted.'
  end

  # GET /race_results or /race_results.json
  def index
    @race_results = @race.results
    authenticate_mod! if @race_results.none?
  end

  def record
    if request.get?
      entrant_count = params.require(:entrant_count).to_i
      max_position_in_points_system = @race.season.points_system.points_allocations.pluck(:position).max
      if entrant_count > max_position_in_points_system
        redirect_to race_results_path(race: @race), notice: "This season's points system is only configured to allocate points " +
          "as far as position #{max_position_in_points_system}. If this race had #{entrant_count} entrants, " + 
          "points allocations must be created for positions #{max_position_in_points_system + 1} through #{entrant_count} " +
          "before recording race results."
      else
        @results = 1.upto(entrant_count).map do |position|
          @race.results.build position: position
        end
      end
    end
    if request.post?
      @results = params.require(:results).map do |result_params|
        result = RaceResult.new(screen_race_result_params(result_params))
        # Handle missing checkboxes
        if !result_params.key?(:scored_pole_position)
          result.scored_pole_position = false
        end
        if !result_params.key?(:finished_race)
          result.finished_race = false
        end
        result.most_laps_led = false
        result
      end
      if @results.map(&:valid?).all? && @results.map(&:save).all?
        @race.award_most_laps_led!
        @race.season.calculate_standings!
        redirect_to races_path(season: @race.season), notice: 'Results successfully recorded.'
      else render :record, notice: 'Not able to record race results.', status: :unprocessable_entity
      end
    end
  end

  # GET /race_results/1 or /race_results/1.json
  def show
  end

  # GET /race_results/new
  def new
    @race_result = RaceResult.new
  end

  # GET /race_results/1/edit
  def edit
  end

  # PATCH/PUT /race_results/1 or /race_results/1.json
  def update
    @race = @race_result.race
    respond_to do |format|
      if @race_result.update(race_result_params)
        @race.award_most_laps_led!
        format.html { redirect_to race_results_path(race: @race), notice: "Race result was successfully updated." }
        format.json { render :show, status: :ok, location: @race_result }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @race_result.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_race
      @race = Race.find params.require(:race)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_race_result
      @race_result = RaceResult.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def race_result_params
      screen_race_result_params(params.require(:race_result))
    end

    def screen_race_result_params(params)
      params.permit(:race_id, :driver_id, :scored_pole_position, :laps_led, :finished_race, :position)
    end
end
