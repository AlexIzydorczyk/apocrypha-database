class CreateProvenances < ActiveRecord::Migration[7.0]
  def change
    create_table :provenances do |t|
      t.references :booklet, null: false, foreign_key: true
      t.string :person, default: ''
      t.string :institution, default: ''
      t.string :location, default: ''
      t.string :religious_order, default: ''
      t.string :diocese, default: ''
      t.string :region, default: ''
      t.integer :owned_from
      t.integer :owned_to
      t.string :specific_date, default: ''
      t.text :notes, default: ''
      t.timestamps
    end
  end
end
