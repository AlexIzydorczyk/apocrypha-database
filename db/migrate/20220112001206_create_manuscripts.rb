class CreateManuscripts < ActiveRecord::Migration[7.0]
  def change
    create_table :manuscripts do |t|
      t.string :identifier, null: false, default: ""
      t.string :census_no, null: false, default: ""
      t.string :status, null: false, default: ""
      t.references :institution, foreign_key: true
      t.string :shelfmark, null: false, default: ""
      t.string :old_shelfmark, null: false, default: ""
      t.string :material, null: false, default: ""
      t.string :dimensions, null: false, default: ""
      t.string :leaf_page_no, null: false, default: ""
      t.string :date_from, null: false, default: ""
      t.string :date_to, null: false, default: ""
      t.string :content_type, null: false, default: ""
      t.text :notes, null: false, default: ""
      t.timestamps
    end
  end
end
