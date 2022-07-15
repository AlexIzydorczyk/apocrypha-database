class AddRequiresTransliterationToLanguages < ActiveRecord::Migration[7.0]
  def change
    add_column :languages, :requires_transliteration, :boolean, null: false, default: false
  end
end
