class ChangeLog < ApplicationRecord
  belongs_to :user
  belongs_to :record, optional: true
end
