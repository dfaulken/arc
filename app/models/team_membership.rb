class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :driver

  validate :driver_in_only_one_team_per_season

  private

  def driver_in_only_one_team_per_season
    if driver.teams.where(season: team.season).count > 1
      errors.add :driver, 'can only be in 1 team per season'
    end
  end
end
