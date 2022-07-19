class AddSequenceNoToPersonReferences < ActiveRecord::Migration[7.0]
  def change
    add_column :person_references, :sequence_no, :integer
  end
end
