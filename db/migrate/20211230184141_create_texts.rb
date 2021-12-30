class CreateTexts < ActiveRecord::Migration[7.0]
  def change
    create_table :texts do |t|
      t.references :parent, polymorphic: true
      t.references :apocryphon, null: false, foreign_key: true
      t.timestamps
    end
  end
end
