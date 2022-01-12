class CreateLanguageReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :language_references do |t|
      t.references :record, null: false, polymorphic: true
      t.references :language, null: false, foreign_key: true
      t.timestamps
    end
  end
end
