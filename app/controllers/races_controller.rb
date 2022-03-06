class RacesController < ApplicationController
  before_action :set_race, only: %i[ show edit update destroy publish_incident_outcomes ]
  before_action :set_season, only: %i[index new ]
  before_action :authenticate_mod!, except: %i[ index show ]

  # GET /races or /races.json
  def index
    if params[:track_type] && TrackType.types.include?(params[:track_type])
      @track_type = params[:track_type]
      track_type = params.require(:track_type)
    else 
      # Don't set instance variable
      track_type = TrackType.any
    end
    @races = @season.races.of_type(track_type)
    @standings = @season.grouped_standings(track_type)
    @team_standings = @season.grouped_team_standings(track_type)
    @drivers = @standings.keys.sort_by {|driver| @standings[driver].position }
    @teams = @team_standings.keys.sort_by{ |team| @team_standings[team].position }
    @results = @season.grouped_results(track_type)
    @scores = @season.grouped_scores(track_type)
    @points_progression = @season.grouped_points_progression(track_type)
  end

  # GET /races/new
  def new
    @race = Race.new
    if @season.races.any?
      @race.date = @season.races.pluck(:date).max + 1.week
    end
  end

  # GET /races/1/edit
  def edit
    @season = @race.season
  end

  # POST /races or /races.json
  def create
    @race = Race.new(race_params)
    @season = @race.season

    respond_to do |format|
      if @race.save
        format.html { redirect_to races_path(season: @season), notice: "Race was successfully created." }
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish_incident_outcomes
    @race.publish_incident_outcomes!
    redirect_to race_results_path(race: @race), notice: 'Incident outcomes published.'
  end

  # PATCH/PUT /races/1 or /races/1.json
  def update
    @season = @race.season
    respond_to do |format|
      if @race.update(race_params)
        format.html { redirect_to races_path(season: @season), notice: "Race was successfully updated." }
        format.json { render :show, status: :ok, location: @race }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1 or /races/1.json
  def destroy
    @race.destroy
    respond_to do |format|
      format.html { redirect_to races_url, notice: "Race was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_race
      @race = Race.find(params[:id])
    end

    def set_season
      @season = Season.find params.require(:season)
    end

    # Only allow a list of trusted parameters through.
    def race_params
      params.require(:race).permit(:season_id, :track_id, :date, :laps)
    end
end
