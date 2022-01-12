class CreateModernSourceReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :modern_source_references do |t|
      t.references :record, null: false, polymorphic: true
      t.references :modern_source, null: false, foreign_key: true
      t.string :specific_page, null: false, default: ""
      t.string :siglum, null: false, default: ""
      t.timestamps
    end
  end
end
