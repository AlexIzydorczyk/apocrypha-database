class AddNullTrueToGridStateUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :user_grid_states, :user_id, true
    add_column :user_grid_states, :state_name, :string, null: false, default: ""
  end
end
