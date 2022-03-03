class AllowNullInModernSourceReference < ActiveRecord::Migration[7.0]
  def change
    change_column_null :modern_source_references, :modern_source_id, true
  end
end
