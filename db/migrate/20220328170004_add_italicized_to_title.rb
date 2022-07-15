class AddItalicizedToTitle < ActiveRecord::Migration[7.0]
  def change
    add_column :titles, :italicized, :boolean, null: false, default: false
  end
end
