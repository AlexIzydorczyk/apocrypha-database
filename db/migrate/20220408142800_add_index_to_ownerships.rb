class AddIndexToOwnerships < ActiveRecord::Migration[7.0]
  def change
    add_column :ownerships, :index, :integer
  end
end
