class AddMainTitlesToApocrypha < ActiveRecord::Migration[7.0]
  def change
    add_reference :apocrypha, :main_english_title, foreign_key: {to_table: :titles}
    add_reference :apocrypha, :main_latin_title, foreign_key: {to_table: :titles}
  end
end
