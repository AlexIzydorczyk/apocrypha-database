class AddOrderToGridStates < ActiveRecord::Migration[7.0]
  def change
    add_column :user_grid_states, :index, :integer
  end
end
