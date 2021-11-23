class RaceResult < ApplicationRecord
  belongs_to :race
  belongs_to :driver
  has_many :scores

  validates :scored_pole_position, inclusion: { in: [true, false] }
  validates :laps_led, presence: true
  validates :finished_race, inclusion: { in: [true, false] }
  validates :position, presence: true

  def calculate_and_persist_score!
    new_score = scores.build points_system: default_points_system
    new_score.calculate!
    new_score.save
  end

  def default_points_system
    race.season.points_system
  end

  def most_laps_led?
    laps_led == race.results.pluck(:laps_led).max
  end

  def score
    scores.find_by points_system: default_points_system
  end
end
