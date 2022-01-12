class CreateApocrypha < ActiveRecord::Migration[7.0]
  def change
    create_table :apocrypha do |t|
      t.string :apocryphon_no, null: false, default: ""
      t.string :cant_no, null: false, default: ""
      t.string :bhl_no, null: false, default: ""
      t.string :bhg_no, null: false, default: ""
      t.string :bho_no, null: false, default: ""
      t.string :e_clavis_no, null: false, default: ""
      t.string :e_clavis_link, null: false, default: ""
      t.timestamps
    end
  end
end
