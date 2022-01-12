class CreateOwnerships < ActiveRecord::Migration[7.0]
  def change
    create_table :ownerships do |t|
      t.references :booklet, null: false, foreign_key: true
      t.references :person, foreign_key: true
      t.references :institution, foreign_key: true
      t.references :location, foreign_key: true
      t.references :religious_order, foreign_key: true
      t.string :date_from, null: false, default: ""
      t.string :date_to, null: false, default: ""
      t.string :date_for_owner, null: false, default: ""
      t.boolean :owner_date_is_approximate, null: false, default: true
      t.text :provenance_notes, null: false, default: ""
      t.timestamps
    end
  end
end
