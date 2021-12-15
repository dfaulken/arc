class Track < ApplicationRecord
  has_many :races

  default_scope { order :name }

  validates :name, presence: true, uniqueness: true
  validates :track_type, presence: true, inclusion: { in: TrackType.types }
end