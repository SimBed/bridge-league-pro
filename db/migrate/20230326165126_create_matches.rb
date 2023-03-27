class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.date :date
      t.float :score
      t.references :winner
      t.references :loser
      t.references :league, null: false, foreign_key: true

      t.timestamps
    end
    add_foreign_key :matches, :players, column: :winner_id, primary_key: :id
    add_foreign_key :matches, :players, column: :loser_id, primary_key: :id
    add_index :matches, :date
    add_index :matches, :score
  end
end
