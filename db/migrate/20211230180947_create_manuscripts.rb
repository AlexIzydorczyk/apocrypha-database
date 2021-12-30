class CreateManuscripts < ActiveRecord::Migration[7.0]
  def change
    create_table :manuscripts do |t|
      t.integer :manuscript_id, null: false
      t.string :status, null: false, default: ""
      t.timestamps
    end
  end
end
