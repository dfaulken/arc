class Championship < ApplicationRecord
  has_many :seasons
  has_many :races, through: :seasons
  has_many :incidents, through: :races
  has_many :outcomes, through: :incidents
  has_many :tracks, through: :races
  has_many :results, through: :seasons
  has_many :championship_drivers
  has_many :drivers, through: :championship_drivers

  default_scope { order :name }

  validates :name, presence: true, uniqueness: true
  validates :number_of_warnings_per_penalty_point, presence: true, if: :warnings_convert_to_penalty_points?

  def combined?
    track_types.count > 1
  end

  def drivers_with_active_published_incident_outcomes
    Driver.find(outcomes.active.published.pluck(:driver_id))
  end

  def finishes(track_type:)
    results.joins(race: :track).where(tracks: { track_type: track_type }).not_disqualified
  end

  def free_numbers_below_100
    0.upto(99).to_a - championship_drivers.pluck(:car_number).compact.map(&:to_i) - [1] # champs
  end

  def laps_completed(track_type:)
    races.joins(:track, :results).where(tracks: { track_type: track_type }).uniq.sum(&:laps)
  end

  def next_season_index
    if seasons.any?(&:persisted?)
      seasons.select(&:persisted?).map(&:index).max.succ
    else 1
    end
  end

  def pole_positions(track_type:)
    finishes(track_type: track_type).where(scored_pole_position: true)
  end

  def races_completed(track_type:)
    races.joins(:track, :results).where(tracks: { track_type: track_type }).uniq.count
  end

  def results_with_any_laps_led(track_type:)
    finishes(track_type: track_type).where('laps_led > 0')
  end

  def results_with_most_laps_led(track_type:)
    results_with_any_laps_led(track_type: track_type)
      .group_by(&:race).values.map do |race_results|
        most_laps_led = race_results.map(&:laps_led).max
        race_results.select do |race_result|
          race_result.laps_led == most_laps_led
        end
      end.flatten
  end

  def track_types
    tracks.pluck(:track_type).uniq
  end

  # TODO this doesn't account for the winner being disqualified
  def wins(track_type:)
    finishes(track_type: track_type).where(position: 1)
  end
end
