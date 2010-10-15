class Project < ActiveRecord::Base
  has_many :releases
end
