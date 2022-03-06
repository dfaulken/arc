class RaceResult < ApplicationRecord
  belongs_to :race
  belongs_to :driver
  has_many :scores

  default_scope { order :position }

  scope :of_type, -> (track_type) { joins(race: :track).where(tracks: { track_type: track_type }) }

  validates :driver, uniqueness: { scope: :race }
  validates :scored_pole_position, inclusion: { in: [true, false] }
  validates :laps_led, presence: true
  validates :finished_race, inclusion: { in: [true, false] }
  validates :position, presence: true
  validates :most_laps_led, inclusion: { in: [true, false] }

  after_create -> { calculate_and_persist_score! }
  after_update -> { scores.each(&:calculate!) && scores.each(&:save) && race.season.calculate_standings! }

  def calculate_score
    new_score = scores.build points_system: default_points_system
    new_score.calculate!
    new_score
  end

  def calculate_and_persist_score!
    calculate_score.save!
  end

  def counts_for_team?(team)
    if race.season.points_system.team_results_counted_per_race && race.season.points_system.team_results_counted_per_race < team.drivers.count
      race.results.where(driver: team.drivers).sort_by do |race_result|
        race_result.score.points
      end.reverse.first(race.season.points_system.team_results_counted_per_race).include? self
    else true
    end
  end

  def default_points_system
    race.season.points_system
  end

  def earned_bonus_points?(points_system)
    (points_system.pole_position_points > 0 && scored_pole_position?) ||
    (points_system.any_lap_led_points > 0 && laps_led > 0) ||
    (points_system.most_laps_led_points > 0 && most_laps_led?) ||
    (points_system.race_finished_points > 0 && finished_race?)
  end

  def score
    scores.find_by points_system: default_points_system
  end
end
