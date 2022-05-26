class ManuscriptUrl < ApplicationRecord
  belongs_to :manuscript

  def to_ary
    [self]
  end

end
