class Race < ApplicationRecord
  belongs_to :season
  belongs_to :track
  has_many :results, class_name: 'RaceResult', inverse_of: :race
  has_many :drivers, through: :results
  has_many :incidents
  has_many :outcomes, through: :incidents

  default_scope { order :date }

  scope :of_type, -> (track_type) { joins(:track).where(tracks: { track_type: track_type }) }

  validates :date, presence: true, uniqueness: { scope: :season }
  validates :laps, presence: true

  def award_most_laps_led!
    most_laps_led = results.pluck(:laps_led).max
    results.where(laps_led: most_laps_led).update_all(most_laps_led: true)
    results.where('laps_led < ?', most_laps_led).update_all(most_laps_led: false)
    results.each do |result|
      result.scores.each do |score|
        score.calculate!
        score.save!
      end
    end
  end

  def name
    "#{track.name} (#{season.name})"
  end

  def of_type?(track_type)
    if track_type == TrackType.any
      true
    else track.track_type == track_type
    end
  end

  def publish_incident_outcomes!
    outcomes.update_all published: true
  end

  def unpublished_outcomes
    outcomes.unpublished
  end

  def warnings
    return [] if results.none?
    messages = []
    poles = results.where(scored_pole_position: true)
    laps_led = results.sum(:laps_led)
    if poles.count != 1
      messages << "should have 1 driver who scored pole position, but hsa #{poles.count}"
    end
    if laps_led != laps
      messages << "should have #{laps} led, but has #{laps_led} led"
    end
    messages
  end
end
