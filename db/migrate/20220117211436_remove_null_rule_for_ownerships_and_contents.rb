class RemoveNullRuleForOwnershipsAndContents < ActiveRecord::Migration[7.0]
  def change
    change_column_null :ownerships, :booklet_id, true
    change_column_null :ownerships, :manuscript_id, true
    change_column_null :contents, :manuscript_id, true
  end
end
