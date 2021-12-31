class AddFieldsToTexts < ActiveRecord::Migration[7.0]
  def change
    add_column :texts, :text_id,                  :integer
    add_column :texts, :folios_pages_text,        :string, default: ""
    add_column :texts, :decoration,               :string, default: ""
    add_column :texts, :folios_pages_title,       :string, default: ""
    add_column :texts, :title,                    :string, default: ""
    add_column :texts, :folios_pages_colophon,    :string, default: ""
    add_column :texts, :colophon,                 :string, default: ""
    add_column :texts, :notes,                    :text, default: ""
    add_column :texts, :transcriptions_by,        :string, default: ""
    add_column :texts, :version,                  :string, default: ""
    add_column :texts, :extent,                   :string, default: ""
    add_column :texts, :online_reproduction,      :string, default: ""
    add_column :texts, :online_transcript,        :string, default: ""
  end
end
