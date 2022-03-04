class Driver < ApplicationRecord
  has_many :race_results
  has_many :races, through: :race_results
  has_many :seasons, through: :races
  has_many :championship_drivers
  has_many :championships, through: :championship_drivers
  has_many :incident_outcomes
  has_many :incidents, through: :incident_outcomes

  default_scope { order :name }

  validates :name, presence: true, uniqueness: true

  def championship_entry(championship)
    championship_drivers.find_by championship: championship
  end

  def current_championship_outcomes(championship)
    incident_outcomes.active.published.joins(incident: { race: :season })
       .where(seasons: { championship_id: championship.id })
  end

  def current_warnings(championship)
    championship_warnings = current_championship_outcomes(championship).where(received_warning: true).uniq.count
    if championship.warnings_convert_to_penalty_points?
      championship_warnings = championship_warnings % championship.number_of_warnings_per_penalty_point
    end
    return championship_warnings
  end

  def current_penalty_points(championship)
    championship_penalty_points = current_championship_outcomes(championship).pluck(:penalty_points).inject(:+) || 0
    if championship.warnings_convert_to_penalty_points?
      championship_warnings = current_championship_outcomes(championship).where(received_warning: true).uniq.count
      championship_penalty_points += championship_warnings / championship.number_of_warnings_per_penalty_point
    end
    championship_penalty_points
  end

  def in_championship_contention?(season:)
    return false unless season.ongoing?
    rounds_still_to_occur = season.races.select do |race|
      race.results.none?
    end
    score_to_beat = season.standings.pluck(:points).max
    race_scores = {}
    season.races.each do |race|
      result = race.results.find_by(driver_id: id)
      race_scores[race] = if result
                            result.scores.find_by(points_system: season.points_system).try(:points)
                          else 0
                          end
    end
    rounds_still_to_occur.each do |race|
      race_scores[race] = season.points_system.max_possible_points_per_race
    end
    scores = race_scores.values
    number_of_rounds_to_drop = 0
    unless season.points_system.worst_rounds_dropped > season.races.count
      number_of_rounds_to_drop = season.points_system.worst_rounds_dropped
    end
    number_of_rounds_to_drop.times do
      scores.delete_at scores.index(scores.min)
    end
    potential_max_score = scores.sum
    potential_max_score >= score_to_beat
  end

  def inferred_championships
    seasons.map(&:championship).uniq
  end

  def last_season_raced(championship)
    races.in_championship(championship).last.try(:season)
  end
end
