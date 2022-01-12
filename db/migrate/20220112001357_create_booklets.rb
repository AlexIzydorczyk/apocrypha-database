class CreateBooklets < ActiveRecord::Migration[7.0]
  def change
    create_table :booklets do |t|
      t.references :manuscript, foreign_key: true
      t.string :booklet_no, null: false, default: ""
      t.string :pages_folios, null: false, default: ""
      t.string :date_from, null: false, default: ""
      t.string :date_to, null: false, default: ""
      t.string :specific_date, null: false, default: ""
      t.references :genesis_location, foreign_key: { to_table: :locations }
      t.references :genesis_institution, foreign_key: { to_table: :institutions }
      t.references :genesis_religious_order, foreign_key: { to_table: :religious_orders }
      t.string :content_type, null: false, default: ""
      t.timestamps
    end
  end
end
