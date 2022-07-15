class AddManuscriptToContents < ActiveRecord::Migration[7.0]
  def change
    add_reference :contents, :manuscript, null: false, foreign_key: true
    add_reference :ownerships, :manuscript, null: false, foreign_key: true
  end
end
