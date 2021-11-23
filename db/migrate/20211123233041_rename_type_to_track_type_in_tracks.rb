class RenameTypeToTrackTypeInTracks < ActiveRecord::Migration[6.1]
  def change
    rename_column :tracks, :type, :track_type
  end
end
