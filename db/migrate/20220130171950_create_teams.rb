class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.integer :season_id
      t.string :name

      t.timestamps
    end
  end
end
