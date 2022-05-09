class AddFiltersToUserGridStates < ActiveRecord::Migration[7.0]
  def change
    add_column :user_grid_states, :filters, :json
  end
end
