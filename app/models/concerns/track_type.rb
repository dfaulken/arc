class TrackType
  OVAL = "oval".freeze
  ROAD = "road".freeze

  def self.any
    types
  end

  def self.types
    [OVAL, ROAD]
  end
end