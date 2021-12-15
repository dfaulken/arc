class AddUnconfirmedEmailToMods < ActiveRecord::Migration[6.1]
  def change
    add_column :mods, :unconfirmed_email, :string
  end
end
