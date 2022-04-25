class CreateUserGridStates < ActiveRecord::Migration[7.0]
  def change
    create_table :user_grid_states do |t|
      t.references :user, null: false, foreign_key: true
      t.string :record_type
      t.json :state
      t.timestamps
    end
  end
end
