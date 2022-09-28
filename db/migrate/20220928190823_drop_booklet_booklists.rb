class DropBookletBooklists < ActiveRecord::Migration[7.0]
  def change
    drop_table :booklet_booklists
  end
end
