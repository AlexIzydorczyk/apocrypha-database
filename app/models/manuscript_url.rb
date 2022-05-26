class ManuscriptUrl < ApplicationRecord
  belongs_to :manuscript
  scope :database, -> { where(url_type: 'database') }
  scope :reproduction, -> { where(url_type: 'reproduction') }

  def to_ary
    [self]
  end

end
