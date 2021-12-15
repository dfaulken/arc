class RemoveIndexFromRaces < ActiveRecord::Migration[6.1]
  def change
    remove_column :races, :index, :integer
  end
end
