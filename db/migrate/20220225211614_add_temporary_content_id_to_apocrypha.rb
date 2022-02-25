class AddTemporaryContentIdToApocrypha < ActiveRecord::Migration[7.0]
  def change
    add_reference :apocrypha, :content, foreign_key: true
  end
end
