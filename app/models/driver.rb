class Driver < ApplicationRecord
  has_many :race_results
  has_many :races, through: :race_results
  has_many :seasons, through: :races
  has_many :championships, through: :seasons
  has_many :incident_outcomes
  has_many :incidents, through: :incident_outcomes

  default_scope { order :name }
  scope :with_car_number, -> { where.not car_number: [nil, ''] }

  validates :name, presence: true, uniqueness: true
  validates :nickname, uniqueness: true, allow_blank: true
  # TODO drivers should have different car numbers per-championship
  validates :car_number, uniqueness: true, 
    format: { with: /\A\d{1,3}\z/, message: 'must contain 1-3 digits' }, allow_blank: true

  def car_number_as_integer
    car_number.to_i
  end

  def current_championship_outcomes(championship)
    incident_outcomes.published.joins(incident: { race: :season })
       .where(seasons: { championship_id: championship.id })
       .where('expires_at > ?', DateTime.now)
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

  # TODO this should go along with car numbers, per-championship
  def last_season_raced
    races.last.try(:season)
  end

  def numbered_name_with_nickname
    str = name
    if car_number.present?
      str = "##{car_number} #{str}"
    end
    if nickname.present?
      str = "#{str} (#{nickname})"
    end
    str
  end

  def self.free_numbers_below_100
    0.upto(99).to_a - Driver.pluck(:car_number).compact.map(&:to_i) - [1] # champs
  end
end
