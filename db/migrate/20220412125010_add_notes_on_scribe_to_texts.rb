class AddNotesOnScribeToTexts < ActiveRecord::Migration[7.0]
  def change
    add_column :texts, :notes_on_scribe, :text, null: false, default: ""
  end
end
