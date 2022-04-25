class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :trackable
  has_many :user_grid_states
  # removing most options for now, will manually create accounts until we open this to public
  # :confirmable, :lockable, :timeoutable, :omniauthable, :registerable, :recoverable, :rememberable

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
