class AddOriginToManuscripts < ActiveRecord::Migration[7.0]
  def change
    add_column :manuscripts, :origin_notes, :text
    add_reference :manuscripts, :genesis_institution, foreign_key: { to_table: :institutions }
    add_reference :manuscripts, :genesis_religious_order, foreign_key: { to_table: :religious_orders }
    add_reference :manuscripts, :genesis_location, foreign_key: { to_table: :locations }
  end
end
