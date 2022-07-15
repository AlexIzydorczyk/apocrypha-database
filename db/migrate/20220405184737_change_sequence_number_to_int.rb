class ChangeSequenceNumberToInt < ActiveRecord::Migration[7.0]
  def change
    change_column_default :contents, :sequence_no,  nil
    change_column :contents, :sequence_no, 'integer USING CAST(sequence_no AS integer)'
  end
end
