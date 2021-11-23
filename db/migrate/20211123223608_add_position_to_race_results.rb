class AddPositionToRaceResults < ActiveRecord::Migration[6.1]
  def change
    add_column :race_results, :position, :integer
  end
end
