class AddOriginNotesToBooklets < ActiveRecord::Migration[7.0]
  def change
    add_column :booklets, :origin_notes, :string, null: false, default: ""
  end
end
