class User < ApplicationRecord
  devise :database_authenticatable, :validatable, :trackable
  # removing most options for now, will manually create accounts until we open this to public
  # :confirmable, :lockable, :timeoutable, :omniauthable, :registerable, :recoverable, :rememberable
end
