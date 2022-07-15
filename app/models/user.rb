class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :trackable, :confirmable, :recoverable, :rememberable
  has_many :user_grid_states
  # removing most options for now, will manually create accounts until we open this to public
  #  :lockable, :timeoutable, :omniauthable, :registerable

  def admin?
    return self.role == 'admin'
  end

  def editor?
    return self.role == 'editor'
  end

  def adm_editor?
    return (self.role == 'admin' || self.role == 'editor')
  end
end
