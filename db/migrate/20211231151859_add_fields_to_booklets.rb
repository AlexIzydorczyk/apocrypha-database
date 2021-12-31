class AddFieldsToBooklets < ActiveRecord::Migration[7.0]
  def change
    add_column :booklets, :booklet_id, :integer
    add_column :booklets, :booklet_num, :integer
    add_column :booklets, :date_from, :integer
    add_column :booklets, :date_to, :integer
    add_column :booklets, :specific_date, :string, default: ""
    add_column :booklets, :scribe_signature, :string, default: ""
    add_column :booklets, :scribe_name, :string, default: ""
    add_column :booklets, :scribe_notes, :text, default: ""
  end
end
