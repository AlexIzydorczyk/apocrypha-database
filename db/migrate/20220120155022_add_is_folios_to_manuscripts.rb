class AddIsFoliosToManuscripts < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscripts, :is_folios, :boolean, null: false, default: true
  end
end
