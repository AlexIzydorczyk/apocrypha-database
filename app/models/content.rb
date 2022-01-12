class Content < ApplicationRecord
  belongs_to :booklet, optional: true
  belongs_to :title, optional: true
  belongs_to :author, class_name: "Person", optional: true
  has_many :texts
end
