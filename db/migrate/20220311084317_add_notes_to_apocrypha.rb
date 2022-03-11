class AddNotesToApocrypha < ActiveRecord::Migration[7.0]
  def change
    add_column :apocrypha, :notes, :text, null: false, default: ""
  end
end
