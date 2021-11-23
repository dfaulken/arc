class CreateSeasons < ActiveRecord::Migration[6.1]
  def change
    create_table :seasons do |t|
      t.integer :championship_id
      t.integer :points_system_id
      t.integer :index
      t.string :name

      t.timestamps
    end
  end
end
