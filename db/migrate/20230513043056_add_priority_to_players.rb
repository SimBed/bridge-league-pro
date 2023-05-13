class AddPriorityToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :priority, :boolean
    add_index :players, :priority
  end
end
