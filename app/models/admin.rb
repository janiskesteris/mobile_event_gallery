class Admin < ActiveRecord::Base
  devise :database_authenticatable, :validatable

  attr_accessible :email, :password, :password_confirmation
end
