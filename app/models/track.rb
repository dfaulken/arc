class Track < ApplicationRecord
  has_many :races

  validates :track_type, inclusion: { in: TrackType.types }
end
