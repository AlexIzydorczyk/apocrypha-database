class CreateBooklets < ActiveRecord::Migration[7.0]
  def change
    create_table :booklets do |t|
      t.string :booklet_type, null: false, default: ""
      t.references :manuscript, null: false, foreign_key: true
      t.timestamps
    end
  end
end
