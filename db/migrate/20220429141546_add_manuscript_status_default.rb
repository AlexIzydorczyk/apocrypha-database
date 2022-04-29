class AddManuscriptStatusDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :manuscripts, :status, "extant"
  end
end
