class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :season
      t.boolean :loser_scores_zero, default: false

      t.timestamps
    end
    add_index :leagues, :name
    add_index :leagues, :season
  end
end
