class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.string :name

      t.timestamps
    end
    add_index :leagues, :name, unique: true
  end
end
