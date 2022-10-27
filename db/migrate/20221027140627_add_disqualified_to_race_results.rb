class AddDisqualifiedToRaceResults < ActiveRecord::Migration[6.1]
  def change
    add_column :race_results, :disqualified, :boolean
  end
end
