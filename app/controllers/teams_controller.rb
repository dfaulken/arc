class TeamsController < ApplicationController
  before_action :authenticate_mod!
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :set_season, only: %i[ index new ]

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
    @eligible_drivers = @season.drivers_without_teams
  end

  # GET /teams/1/edit
  def edit
    @season = @team.season
    @eligible_drivers = (@season.drivers_without_teams + @team.drivers).sort_by(&:name)
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    @team.drivers = Driver.find(params.require(:team).require(:drivers))
    @season = @team.season

    respond_to do |format|
      if @team.save
        format.html { redirect_to teams_url(season: @team.season), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    @season = @team.season
    respond_to do |format|
      if @team.update(team_params) && @team.drivers = Driver.find(params.require(:team).require(:drivers))
        format.html { redirect_to teams_url(season: @team.season), notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url(season: @team.season), notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_season
      @season = Season.find params.require(:season)
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:season_id, :name)
    end
end
