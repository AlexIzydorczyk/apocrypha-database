class AddBookletCompositionToManuscripts < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscripts, :known_booklet_composition, :boolean, null: false, default: true
  end
end
