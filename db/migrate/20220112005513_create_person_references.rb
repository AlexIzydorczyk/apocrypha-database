class CreatePersonReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :person_references do |t|
      t.references :record, null: false, polymorphic: true
      t.references :person, null: false, foreign_key: true
      t.timestamps
    end
  end
end
