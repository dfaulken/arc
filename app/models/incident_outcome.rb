class IncidentOutcome < ApplicationRecord
  belongs_to :incident
  belongs_to :driver

  validates :penalty_points, numericality: { greater_than_or_equal_to: 0 }
  validates :explanation, presence: true
  validates :driver, uniqueness: { scope: :incident }

  scope :active, -> { where 'expires_at > ?', DateTime.now }
  scope :published, -> { where published: true }
  scope :unpublished, -> { where.not published: true }

  def default_expiration_date
    incident.race.date + 6.months
  end

end
