class AddIsDefaultToUserGridStates < ActiveRecord::Migration[7.0]
  def change
    add_column :user_grid_states, :is_default, :boolean, null: false, default: false
  end
end
