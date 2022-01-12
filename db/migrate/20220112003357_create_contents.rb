class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.references :booklet, foreign_key: true
      t.string :sequence_no, null: false, default: ""
      t.references :title, foreign_key: true
      t.references :author, foreign_key: { to_table: :people }
      t.timestamps
    end
  end
end
