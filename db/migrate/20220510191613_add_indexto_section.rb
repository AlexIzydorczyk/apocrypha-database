class AddIndextoSection < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :index, :integer
  end
end
