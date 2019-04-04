class User < ActiveRecord::Base
  has_secure_password

  has_many :project_ideas

end
