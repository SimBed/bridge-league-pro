class ChangeDefaultValueForPlayerPriority < ActiveRecord::Migration[7.0]
  def change
    change_column_default :players, :priority, from: nil, to: false
  end
end
