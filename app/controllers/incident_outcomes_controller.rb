class IncidentOutcomesController < ApplicationController
  before_action :set_incident_outcome, only: %i[ show edit update destroy ]
  before_action :authenticate_mod!
  before_action :set_incident, only: %i[ new edit ]

  # GET /incident_outcomes or /incident_outcomes.json
  def index
    @incident_outcomes = IncidentOutcome.all
  end

  # GET /incident_outcomes/1 or /incident_outcomes/1.json
  def show
  end

  # GET /incident_outcomes/new
  def new
    @incident_outcome = IncidentOutcome.new
    @incident_outcome.incident = @incident
  end

  # GET /incident_outcomes/1/edit
  def edit
  end

  # POST /incident_outcomes or /incident_outcomes.json
  def create
    @incident_outcome = IncidentOutcome.new(incident_outcome_params)

    respond_to do |format|
      if @incident_outcome.save
        format.html { redirect_to race_results_path(race: @incident_outcome.incident.race), notice: "Incident outcome was successfully created." }
        format.json { render :show, status: :created, location: @incident_outcome }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @incident_outcome.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incident_outcomes/1 or /incident_outcomes/1.json
  def update
    respond_to do |format|
      if @incident_outcome.update(incident_outcome_params)
        format.html { redirect_to @incident_outcome, notice: "Incident outcome was successfully updated." }
        format.json { render :show, status: :ok, location: @incident_outcome }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @incident_outcome.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incident_outcomes/1 or /incident_outcomes/1.json
  def destroy
    @incident_outcome.destroy
    respond_to do |format|
      format.html { redirect_to incident_outcomes_url, notice: "Incident outcome was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident_outcome
      @incident_outcome = IncidentOutcome.find(params.require(:id))
    end

    def set_incident
      @incident = Incident.find(params.require(:incident))
    end

    # Only allow a list of trusted parameters through.
    def incident_outcome_params
      params.require(:incident_outcome).permit(:incident_id, :driver_id, :received_warning, :penalty_points, :expires_at, :explanation, :published)
    end
end
