class Incident < ApplicationRecord
  belongs_to :race
  has_many :outcomes, class_name: 'IncidentOutcome', inverse_of: :incident

  validates :lap_number, inclusion: { in: 0.upto(race.laps) }
  validates :reported_by, presence: true
  validates :drivers_involved, presence: true
  validates :description, presence: true, uniqueness: { scope: :race }
end
