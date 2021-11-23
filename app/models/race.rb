class Race < ApplicationRecord
  belongs_to :season
  belongs_to :track
  has_many :results, class_name: 'RaceResult', inverse_of: :race

  validates :date, presence: true
  validates :index, presence: true, uniqueness: { scope: :season }
  validates :laps, presence: true
end
