class SeasonStanding < ApplicationRecord
  belongs_to :season
  belongs_to :driver
  has_many :dropped_races

  validates :driver, uniqueness: { scope: [:season, :track_type] }
  validates :season, uniqueness: { scope: [:driver, :track_type] }
  validates :points, presence: true
  validates :position, presence: true
  validates :track_type, presence: true, allow_blank: true, 
    uniqueness: { scope: [:driver, :season] }

  def base_points
    points + dropped_points
  end    

  def dropped_points
    dropped_races.sum(&:points)
  end

  def drops?(race_result)
    dropped_races.pluck(:race_result_id).include? race_result.id
  end

  def self.effective_track_type(track_type)
    if track_type == TrackType.any
      nil
    else track_type
    end
  end
end
