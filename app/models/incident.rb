class Incident < ApplicationRecord
  belongs_to :race
  has_many :outcomes, class_name: 'IncidentOutcome', inverse_of: :incident, dependent: :destroy

  validates :lap_number, inclusion: { in: ->(incident) { 0.upto(incident.race.laps) } }
  validates :reported_by, presence: true
  validates :drivers_involved, presence: true
  validates :description, presence: true, uniqueness: { scope: :race }

  def name
    "#{race.name} - Lap #{lap_number}: #{drivers_involved}"
  end

  def visible_outcomes(is_mod)
    if is_mod
      outcomes
    else outcomes.published
    end
  end
end
