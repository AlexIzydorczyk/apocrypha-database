class AddLanguageReferenceToPerson < ActiveRecord::Migration[7.0]
  def change
    add_reference :people, :language, foreign_key: true
  end
end
