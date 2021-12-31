class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.references :text, null: false, foreign_key: true
      t.timestamps
    end
  end
end
