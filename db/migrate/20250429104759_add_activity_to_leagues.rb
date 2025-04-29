class AddActivityToLeagues < ActiveRecord::Migration[7.0]
  def change
    add_column :leagues, :activity, :string, null: false, default: 'Bridge'
    add_column :leagues, :match_total, :integer
    add_index :leagues, :activity
  end
end
